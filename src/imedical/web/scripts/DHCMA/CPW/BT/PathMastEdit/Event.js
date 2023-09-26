//页面Event
function InitPathMastListWinEvent(obj){	
	//弹窗初始化
	$('#winPathMastEdit').dialog({
		title: '路径字典维护',
		iconCls:"icon-w-paper",
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
	     	$HUI.dialog('#winPathMastEdit').close();
     	});
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer("");
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rowData=obj.gridPathMast.getSelected()
			obj.layer(rowData);	
     	});
		//删除
     	$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     }
	//选择路径字典
	obj.gridPathMast_onSelect = function (){
		var rowData = obj.gridPathMast.getSelected();
		if($("#btnEdit").hasClass("l-btn-disabled")) obj.RecRowID="";
		
		if (rowData["BTID"] == obj.RecRowID) {
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.RecRowID="";
			obj.cboHospValue = "";
			obj.gridPathMast.clearSelections();
		}
		else {
			obj.RecRowID = rowData["BTID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");	
			obj.cboHospValue = 	rowData["HospOIDList"];	
		}	
	}	
	//双击编辑事件
	obj.gridPathMast_onDbselect = function(rowData){
		obj.layer(rowData);
	}	
	//保存分类
	obj.btnSave_click = function(){
		var errinfo = "";
		var myDate = new Date();
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var BTTypeDr   =$('#cboTypeDr').combobox('getValue');
		var BTEntityDr = $('#cboEntityDr').combobox('getValue');
		var BTPCEntityDr = $('#cboPCEntityDr').combobox('getValue');
		var BTQCEntityDr = $('#cboQCEntityDr').combobox('getValue');
		var IsActive = $("#chkIsActive").checkbox('getValue')? '1':'0';
		var BTActDate ='';
		var BTActTime='';
		var BTActUserID="";
		if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];
		var BTAdmType   =$('#AdmType').combobox('getValue');
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathMast",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
	  	}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + BTTypeDr;
		inputStr = inputStr + CHR_1 + BTEntityDr;
		inputStr = inputStr + CHR_1 + BTPCEntityDr;
		inputStr = inputStr + CHR_1 + BTQCEntityDr;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + BTActDate;
		inputStr = inputStr + CHR_1 + BTActTime;
		inputStr = inputStr + CHR_1 + BTActUserID;
		inputStr = inputStr + CHR_1 + BTAdmType;
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathMast",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			}else if (parseInt(flg) == -2) {
				$.messager.alert("错误提示", "数据重复!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathMastEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.RecRowID = flg;
			var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathHosp",
					MethodName:"Clear",
					Parref:obj.RecRowID
				},false);
			var HospArr=obj.cboHospValue.split("^");
			var HospNum=HospArr.length;
			for(var ind=0;ind<HospNum;ind++){
				var ChildID=HospArr[ind].split("-")[1];
				var HospID=HospArr[ind].split("-")[0];
				var inputStr=obj.RecRowID+"^"+ChildID+"^"+HospID+"^"+1+"^"+session['DHCMA.USERID'];
				console.log(inputStr)
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathHosp",
					MethodName:"Update",
					aInputStr:inputStr,
					aSeparete:"^"
				},false);
			}
			obj.gridPathMast.reload() ;//刷新当前页
		}

	}
	
	//删除分类 
	obj.btnDelete_click = function(){
		var rowDataID = obj.gridPathMast.getSelected()["BTID"];
		if (rowDataID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathMast",
					MethodName:"DeleteById",
					aId:rowDataID
				},false);
				
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = ""
					obj.gridPathMast.reload() ;//刷新当前页
				}
			} 
		});
	}
	//配置窗体-初始化
	obj.layer= function(rowData){
		if(rowData){
			obj.RecRowID=rowData["BTID"];
			var Code = rowData["BTCode"];
			var Desc = rowData["BTDesc"];
			var BTTypeID = rowData["BTTypeID"];
			var BTEntityID = rowData["BTEntityID"];
			var BTPCEntityID = rowData["BTPCEntityID"];
			var BTQCEntityID = rowData["BTQCEntityID"];
			var BTIsActive = rowData["BTIsActive"];
			BTIsActive = (BTIsActive=="是"? true: false)
			var BTAdmType = rowData["BTAdmType"];
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboTypeDr').combobox('setValue',BTTypeID);
			$('#cboEntityDr').combobox('setValue',BTEntityID);
			$('#cboPCEntityDr').combobox('setValue',BTPCEntityID);
			$('#cboQCEntityDr').combobox('setValue',BTQCEntityID);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
			$('#AdmType').combobox('setValue',BTAdmType);
			obj.cboHospValue = rowData["HospOIDList"]
			
			var data=$('#cboHosp').combobox('getData');
			for (var jnd=0;jnd<data.length;jnd++){
				var IsSelected=false;
				var HospArr=obj.cboHospValue.split("^");
				for(var ind=0;ind<HospArr.length;ind++){
					if(data[jnd]['OID']==HospArr[ind].split("-")[0]) {
						IsSelected=true;
					}
				}
				if(IsSelected) {
					$('#cboHosp').combobox('select',data[jnd]['OID']);
				}else{
					$('#cboHosp').combobox('unselect',data[jnd]['OID']);
				}
			}
		}else{
			obj.RecRowID="";
			obj.cboHospValue = "";
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#cboTypeDr').combobox('setValue','');
			$('#cboEntityDr').combobox('setValue','');
			$('#cboPCEntityDr').combobox('setValue','');
			$('#cboQCEntityDr').combobox('setValue','');
			$('#chkIsActive').checkbox('setValue',false);
			$('#AdmType').combobox('setValue','');
			var data=$('#cboHosp').combobox('getData');
			for (var jnd=0;jnd<data.length;jnd++){
				$('#cboHosp').combobox('unselect',data[jnd]['OID']);
			}
		}
		$HUI.dialog('#winPathMastEdit').open();
	}
}