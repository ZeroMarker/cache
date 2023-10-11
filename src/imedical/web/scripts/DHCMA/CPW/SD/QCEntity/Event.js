//页面Event
function InitviewScreenEvent(obj){	
	
	//按钮初始化
	$('#winProEdit').dialog({
		title: '质控病种维护',
		iconCls:'icon-w-paper',
		closed: true,
		modal: true,
		isTopZindex:false,//true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.btnSave_click();								
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#winProEdit').close();
			}
		}]
	});
	
	obj.LoadEvent = function(args){ 
		$('#btnAdd').on('click', function(){
			$('#txtCode').removeAttr("disabled"); 
			obj.layer();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridQcEntity.getSelected();
			obj.layer(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
     }
    //双击编辑事件
	obj.gridQcEntity_onDbselect = function(rd){
		obj.layer(rd);
	}
	//选择
	obj.gridQcEntity_onSelect = function (){
		var rowData = obj.gridQcEntity.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		if (rowData["BTID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridQcEntity.clearSelections();
		} else {
			obj.RecRowID = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	//保存产品定义
	obj.btnSave_click = function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var Abbrev = $('#txtAbbrev').val();
		var IndNo = $('#txtIndNo').val();
		var Pubdate = $('#Pubdate').val();
		var IsActive = $('#IsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		var OperKey = $('#txtOperKey').val();
		var URL = $('#txtURL').val();
		var Location=$('#chkLocation').combobox('getValues').join(',');
		var TotalFee = $('#txtTotalFee').val();
		var InDays = $('#txtInDays').val();
		var EntityCat=$('#chkEntityCat').combobox('getValue');
		if (!Code) {
			errinfo = errinfo + "编码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (!URL) {
			errinfo = errinfo + "接口地址为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var inputStr = obj.RecRowID;
		var CHR_1="^";
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + Abbrev;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + IndNo;
		inputStr = inputStr + CHR_1 + Pubdate;
		inputStr = inputStr + CHR_1 + OperKey;
		inputStr = inputStr + CHR_1 + URL;
		inputStr = inputStr + CHR_1 + Location;
		inputStr = inputStr + CHR_1 + TotalFee;
		inputStr = inputStr + CHR_1 + InDays;
		inputStr = inputStr + CHR_1 + EntityCat;
		inputStr = inputStr + CHR_1 + obj.Version;
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.QCEntity",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else if(parseInt(flg) == -2){
				$.messager.alert("错误提示", "数据重复!" , 'info');
			}else{
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winProEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridQcEntity.clearSelections();
			obj.RecRowID="";
			obj.gridQcEntity.reload() ;//刷新当前页
		}
	}
	//删除产品定义
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		
		$.messager.confirm("删除", "删除后对应所有病种数据清空，确定删除？", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.SD.QCEntity",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("错误提示","系统参数配置不允许删除！", 'info');
					} else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridQcEntity.reload() ;//刷新当前页
				}
			} 
		});
	}
    //配置窗体-初始化
	obj.layer= function(rd){

		if(rd){
			obj.RecRowID=rd["BTID"];
			var Code = rd["BTCode"];
			var Desc = rd["BTDesc"];

			var Abbrev = rd["BTAbbrev"];
			var IndNo = rd["BTIndNo"];
			var IsActive = rd["BTIsActive"];
			IsActive = (IsActive=='是'? true: false);
			var Pubdate = rd["BTPubdate"];
			var OperKey = rd["BTOperKey"];
			var URL = rd["BTURL"];
			var BTLocOID = rd["BTLocOID"]
			var BTLocation = rd["BTLocation"]
			var BTEntityCat = rd["BTEntityCat"]
			BTLocOIDArr=BTLocOID.split(",")
			$('#txtCode').val(Code);
			$('#txtCode').attr("disabled",true); 
			$('#txtDesc').val(Desc);
			$('#txtAbbrev').val(Abbrev);
			$('#txtIndNo').val(IndNo);
			$('#IsActive').checkbox('setValue',IsActive);
			$('#Pubdate').val(Pubdate);
			$('#txtOperKey').val(OperKey);
			$('#txtURL').val(URL);
			$('#chkLocation').combobox('setValues',BTLocOIDArr)
			$('#txtTotalFee').val(rd["BTTotalFee"]);
			$('#txtInDays').val(rd["BTInDays"]);
			$('#chkEntityCat').combobox('setValue',BTEntityCat)
		}else{
			obj.RecRowID = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtAbbrev').val('');
			$('#txtIndNo').val('');
			$('#IsActive').checkbox('setValue',false);
			$('#Pubdate').val('');
			$('#chkLocation').combobox('setValues','');
			$('#txtURL').val('');
			$('#txtOperKey').val('');
			$('#chkEntityCat').combobox('setValue','')
		}
		$HUI.dialog('#winProEdit').open();
	}
}
