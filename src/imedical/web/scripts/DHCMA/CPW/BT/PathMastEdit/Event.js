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
	
	//导出类型初始化
	$('#winChkExportType').dialog({
		title: '选择导出类型',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
	});	
	
	// 检查删除按钮是否允许删除，若否则隐藏该按钮
	if(!chkDelBtnIsAble("DHCMA.CPW.BT.PathMast")){
		$("#btnDelete").hide();	
	}else{
		$("#btnDelete").show();	
	}
	
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
			var rowData=obj.gridPathMast.getSelected();
			obj.layer(rowData);	
     	});
		//删除
     	$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	//导出
     	$("#btnExport").on('click', function(){
	     	var arrRows = obj.gridPathMast.getSelections();
	     	if (arrRows.length == 0){
		    	$.messager.alert($g("提示"), $g("请先选中要导出的记录"), 'info');
				return; 	
		    }else{
				$HUI.dialog('#winChkExportType').open();    
			}
	    })
	    //导出类型选择
	    $("#btnExpSave").on('click',function(){
			obj.batExpForm_click();    
		})
	    
     }
	//选择路径字典
	obj.gridPathMast_onSelect = function (){
		var arrRows = obj.gridPathMast.getSelections();
		var rowData=arrRows[0];
		
		if (arrRows.length==1){
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			$("#btnExport").linkbutton("enable");
			obj.RecRowID = rowData["BTID"];
			obj.cboHospValue = 	rowData["HospOIDList"];		
		}else if(arrRows.length > 1){
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("enable");
			$("#btnExport").linkbutton("enable");
			obj.RecRowID="";
			obj.cboHospValue = "";
		}else{
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnExport").linkbutton("disable");
			obj.RecRowID="";
			obj.cboHospValue = "";
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
		var IsOper	 = $("#chkIsOper").checkbox('getValue')?'1':'0';
		var StaCategoryDr = $("#cboStaCategory").combobox('getValue');
		var IsCompl	 = $("#chkIsCompl").checkbox('getValue')?'1':'0';
		var BTActDate ='';
		var BTActTime='';
		var BTActUserID="";
		if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];
		var BTAdmType   =$('#AdmType').combobox('getValue');
		if (!Code) {
			errinfo = errinfo + $g("代码为空!<br>");
		}
		if (!Desc) {
			errinfo = errinfo + $g("名称为空!<br>");
		}
		if (!BTTypeDr) {
			errinfo = errinfo + $g("路径类型为空!<br>");
		}
		if (!BTAdmType) {
			errinfo = errinfo + $g("就诊类型为空!<br>");
		}
		
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathMast",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.RecRowID
		},false);
	  	if(IsCheck>=1) {
	  		errinfo = errinfo + $g("代码与列表中现有项目重复，请检查修改!<br>");
	  	}
		if (errinfo) {
			$.messager.alert($g("错误提示"), errinfo, 'info');
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
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + IsOper;
		inputStr = inputStr + CHR_1 + StaCategoryDr;
		inputStr = inputStr + CHR_1 + IsCompl;
		
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathMast",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1,
			aHospID: $("#cboSSHosp").combobox('getValue')
		},false);
		
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert($g("错误提示"), $g("参数错误!") , 'info');
			}else if (parseInt(flg) == -2) {
				$.messager.alert($g("错误提示"), $g("数据重复!") , 'info');
			} else {
				$.messager.alert($g("错误提示"), $g("更新数据错误!Error=") + flg, 'info');
			}
		}else {
			$HUI.dialog('#winPathMastEdit').close();
			$.messager.popover({msg: $g('保存成功！'),type:'success',timeout: 1000});
			
			if(obj.retMultiHospCfg=="Y" || obj.retMultiHospCfg=="1") {		//启用平台多院区配置，则不再处理路径子表的院区关联
				obj.gridPathMast.reload();//刷新当前页
				return;
			}		
			obj.RecRowID = flg;
			var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathHosp",
					MethodName:"Clear",
					Parref:obj.RecRowID
				},false);
			//var HospArr=obj.cboHospValue.split("^"); 
			var HospArr=obj.cboHosp.getValues();
			var HospNum=HospArr.length;
			for(var ind=0;ind<HospNum;ind++){
				//var ChildID=HospArr[ind].split("-")[1];
				var HospID=HospArr[ind];
				var inputStr=obj.RecRowID+"^"+"^"+HospID+"^"+1+"^"+session['DHCMA.USERID'];
				//console.log(inputStr)
				var flg = $m({
					ClassName:"DHCMA.CPW.BT.PathHosp",
					MethodName:"Update",
					aInputStr:inputStr,
					aSeparete:"^"
				},false);
			}
			obj.gridPathMast.reload();//刷新当前页
		}

	}
	
	//删除分类 
	obj.btnDelete_click = function(){
		var arrRows = obj.gridPathMast.getSelections();
		if (arrRows.length==0){
			$.messager.alert($g("提示"), $g("选中数据记录,再点击删除!"), 'info');
			return;
		}else{
			$.messager.confirm($g("删除"), $g("删除操作不可恢复，确定删除选中记录?"), function (r) {
				$.each(arrRows, function(index, item){
					var rowDataID = item["BTID"];
					if (r) {				
						flg = $m({
							ClassName:"DHCMA.CPW.BT.PathMast",
							MethodName:"DeleteById",
							aId:rowDataID,
							aHospID: $("#cboSSHosp").combobox('getValue')
						},false);
						
						if (parseInt(flg) < 0) {
							if (parseInt(flg)==-777) {
								$.messager.alert($g("错误提示"),$g("系统参数配置不允许删除！"), 'info');
								return false;
							} 
						}else{
							$.messager.popover({msg: $g('删除成功！'),type:'success',timeout: 1000});
							obj.RecRowID = ""
							obj.gridPathMast.reload() ;//刷新当前页	
						}
					} 
				});	
			});	
		}
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
			var BTPathComplID = rowData["PathComplID"];
			var BTIsActive = rowData["BTIsActive"];
			BTIsActive = (BTIsActive==$g("是")? true: false)
			var BTAdmType = rowData["BTAdmType"];
			var BTIsOper = rowData["IsOper"];
			var BTStaCategoryID = rowData["StaCategoryID"];
			var BTIsCompl = rowData["IsAsCompl"]
			
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#cboTypeDr').combobox('setValue',BTTypeID);
			$('#cboEntityDr').combobox('setValue',BTEntityID);
			$('#cboPCEntityDr').combobox('setValue',BTPCEntityID);
			$('#cboQCEntityDr').combobox('setValue',BTQCEntityID);
			$('#chkIsActive').checkbox('setValue',BTIsActive);
			$('#AdmType').combobox('setValue',BTAdmType);
			$('#chkIsOper').checkbox('setValue',BTIsOper);
			$('#cboStaCategory').combobox('setValue',BTStaCategoryID);
			$('#chkIsCompl').checkbox('setValue',BTIsCompl)
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
			$('#chkIsOper').checkbox('setValue',false);
			$('#cboStaCategory').combobox('setValue','');
			$('#AdmType').combobox('setValue','');
			$('#chkIsCompl').checkbox('setValue',false)
			var data=$('#cboHosp').combobox('getData');
			for (var jnd=0;jnd<data.length;jnd++){
				$('#cboHosp').combobox('unselect',data[jnd]['OID']);
			}
		}
		$HUI.dialog('#winPathMastEdit').open();
	}
	
	//批量导出事件
	obj.batExpForm_click = function(){
		var expType= $("input[name='exp']:checked").val();
		if (expType == undefined){
			$.messager.popover({
				msg: $g('请先选择要导出的类型！'),
				type: 'info',
				timeout: 2000, 		//0不自动关闭。3000s
				showSpeed: 'slow', //fast,slow,normal,1500
				showType: 'fade'  //show,fade,slide
			});
		}else{
			$HUI.dialog('#winChkExportType').close();	
		}
		var arrRows = obj.gridPathMast.getSelections();
		if (expType=="form"){
			$.each(arrRows, function(index, item){
				var FormID = item["FormID"];
				if (FormID == "") return true;
				var FormName=item["BTDesc"] + "(" + item["FromVer"] + ")";
				ExportForm(FormID,FormName);
			})
		}else if (expType=="order"){
			$.each(arrRows, function(index, item){
				var FormID = item["FormID"];
				if (FormID == "") return true;
				var FormName=item["BTDesc"] + "(" + item["FromVer"] + ")";
				ExportOrd(FormID,FormName);
			})
		}else{
			return;	
		}
	}
	
}