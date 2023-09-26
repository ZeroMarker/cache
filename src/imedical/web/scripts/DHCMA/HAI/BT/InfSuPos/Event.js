//页面Event
function InitInfSuPosWinEvent(obj){	
    
    obj.LoadEvent = function(args){ 
	 	  
		//添加疑似诊断
		$('#btnAddPos').on('click', function(){
			obj.InitPosDialog();
		});
		 //疑似诊断保存
		$('#btnPosSave').on('click', function(){
	     	obj.btnPosSave_click();
     	});
		//疑似诊断关闭
		$('#btnPosClose').on('click', function(){
	     	$HUI.dialog('#InfSuPosEdit').close();
     	});
		
	    //添加关键词
		$('#btnAddKey').on('click', function(){
			obj.InitKeyDialog();
		});
		 //关键词保存
		$('#btnKeySave').on('click', function(){
	     	obj.btnKeySave_click();
     	});
		//关键词关闭
		$('#btnKeyClose').on('click', function(){
	     	$HUI.dialog('#SuPosKeyEdit').close();
     	});
		
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridInfSuPos.getSelected();
		    var flg =0;
			if (obj.PosRowID) flg =1;
			obj.InitDialog(rd,flg);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
		//检索框
		$('#searchbox').searchbox({ 
			searcher:function(value,name){ 
				obj.gridInfSuPos.load({
					ClassName:'DHCHAI.IRS.CRuleInfSuSrv',
					QueryName:'QryInfSuPos',
					aAlias:value
				});
			}	
		});

     
	}
    
	//窗体初始化
	obj.InfSuPosEdit = function() {
		$('#InfSuPosEdit').dialog({
			title:'疑似诊断维护',
			iconCls:'icon-w-edit',  
			modal: true,
			isTopZindex:true
		});
	}
	
	//新增诊断窗口初始化
	obj.InitPosDialog = function(){
		obj.PosRowID = "";
		$('#cboInfPos').combobox('clear');
		$('#txtDiag').val('');
		
		$('#InfSuPosEdit').show();
		obj.InfSuPosEdit();
	}
	
	//窗体初始化
	obj.SuPosKeyEdit = function() {
		$('#SuPosKeyEdit').dialog({
			title:'疑似诊断关键词维护',
			iconCls:'icon-w-edit',  
			modal: true,
			isTopZindex:true
		});
	}
		
	
	//新增关键词窗口初始化
	obj.InitKeyDialog = function(){
		obj.KeyRowID = "";
		if (obj.PosRowID) {
			var rowData = obj.gridInfSuPos.getSelected();
			var SuPosID = rowData.SuPosID;
			var InfPos = rowData.InfPos;
			$('#cboSuPos').combobox('disable');
			$('#cboSuPos').combobox('setValue',SuPosID);
			$('#cboSuPos').combobox('setText',InfPos);
		}else {
			$('#cboSuPos').combobox('enable');
			$('#cboSuPos').combobox('clear');
		}
		$('#cboKeyCate').combobox('clear');
		$('#cboPRI').combobox('clear');
		$('#txtCondition').val('');
		$('#txtNote').val('');
		$('#txtKeyWord').val('');
		$('#chkProperty').checkbox('setValue',true);
		$('#chkIsCurrent').checkbox('setValue','');
		$('#SuPosKeyEdit').show();
		obj.SuPosKeyEdit();
	}
	
	//单击选中事件
	obj.gridInfSuPos_onSelect = function (rowData,flg){	
		if (flg==0) {  //关键词
			if (rowData["ID"] == obj.KeyRowID) {
				obj.KeyRowID="";
				$("#btnAddPos").linkbutton("enable");
				$("#btnAddKey").linkbutton("enable");
				$("#btnEdit").linkbutton("disable");
				$("#btnDelete").linkbutton("disable");
				
				obj.gridInfSuPos.clearSelections();  //清除选中行
			} else {
				obj.PosRowID="";
				obj.KeyRowID = rowData["ID"];
				$("#btnAddPos").linkbutton("disable");
				$("#btnAddKey").linkbutton("disable");
				$("#btnEdit").linkbutton("enable");
				$("#btnDelete").linkbutton("enable");
			}
		}else {   //疑似诊断
			if (rowData["SuPosID"] == obj.PosRowID) {
				obj.PosRowID="";
				$("#btnAddPos").linkbutton("enable");
				$("#btnAddKey").linkbutton("enable");
				$("#btnEdit").linkbutton("disable");
				$("#btnDelete").linkbutton("disable");
				
				obj.gridInfSuPos.clearSelections();  //清除选中行
			} else {
				obj.KeyRowID="";
				obj.PosRowID = rowData["SuPosID"];
				$("#btnAddPos").linkbutton("disable");
				$("#btnAddKey").linkbutton("enable");
				$("#btnEdit").linkbutton("enable");
				$("#btnDelete").linkbutton("enable");
			}
			
		}
	}	
	
    //双击弹出编辑事件
	obj.gridInfSuPos_onDbselect = function (rd,flg){
		obj.InitDialog(rd,flg);
	}
	//窗口初始化
	obj.InitDialog = function(rd,flg){		
		if (flg==0) {   //关键词	
			obj.KeyRowID = rd["ID"];
			$('#cboSuPos').combobox('disable');
			var SuPosID = rd["SuPosID"];
			var InfPos = rd["InfPos"];
			var KeyWord = rd["KeyWord"];	
			var PRIID = rd["PRIID"];
			var PRIDesc = rd["PRIDesc"];
			var Note = rd["Note"];
			var CateID = rd["CateID"];
			var CateDesc = rd["CateDesc"];	
			var IsCurrent = rd["IsCurrent"];
			var Property = rd["Property"];
			
			$('#cboSuPos').combobox('setValue',SuPosID);
			$('#cboSuPos').combobox('setText',InfPos);
			$('#cboKeyCate').combobox('setValue',CateID);
			$('#cboKeyCate').combobox('setText',CateDesc);
			$('#cboPRI').combobox('setValue',PRIID);
			$('#cboPRI').combobox('setText',PRIDesc);
			$('#txtKeyWord').val(KeyWord);
			$('#txtNote').val(Note);	
			$('#chkProperty').checkbox('setValue',(Property=="包含" ? true:false));
			$('#chkIsCurrent').checkbox('setValue',(IsCurrent==1 ? true:false));
	
			$('#SuPosKeyEdit').show();
			obj.SuPosKeyEdit();
		}else {
	
			obj.PosRowID = rd["SuPosID"];
			var InfPosID = rd["InfPosID"];
			var InfPos = rd["InfPos"];
			var Diagnos = rd["Diagnos"];
			$('#cboInfPos').combobox('setValue',InfPosID);
			$('#cboInfPos').combobox('setText',InfPos);
			$('#txtDiag').val(Diagnos);	
			
			$('#InfSuPosEdit').show();
			obj.InfSuPosEdit();
		}
	}
	
	//疑似诊断保存
	obj.btnPosSave_click = function(){
		var errinfo = "";
		
		var InfPosDr = $.trim($('#cboInfPos').combobox('getValue')); 
		var Diagnos = $.trim($('#txtDiag').val());
		
		if (!Diagnos){
			errinfo = errinfo + "疑似诊断不允许为空!<br>";
		}
		if (!InfPosDr) {
			errinfo = errinfo + "感染部位不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.PosRowID;
		inputStr += "^" + Diagnos;        // 疑似诊断
		inputStr += "^" + InfPosDr;       // 感染部位
		inputStr += "^" + "";             // 处置日期
		inputStr += "^" + "";             // 处置时间
		inputStr += "^" + $.LOGON.USERID; // 处置人
	
		var flg = $m({
			ClassName:"DHCHAI.BT.InfSuPos",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
	
		if (parseInt(flg) <= 0) {
			if(parseInt(flg)==-2)
			{
				$.messager.alert("失败提示", "更新数据失败,疑似诊断不允许重复!", 'info');
			}
			else
				$.messager.alert("失败提示", "更新数据失败!返回码=" + flg, 'info');
			return;
		}else {
			$HUI.dialog('#InfSuPosEdit').close();
			obj.PosRowID="";
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridInfSuPos.reload() ;//刷新当前页
		}
	}
	
	//关键词保存
	obj.btnKeySave_click = function(){
		var errinfo = "";
		
		var SuPosID = $('#cboSuPos').combobox('getValue'); 
		var KeyWord = $('#txtKeyWord').val();
		var CateID = $('#cboKeyCate').combobox('getValue');
		var PRIID = $('#cboPRI').combobox('getValue');
		var Note = $('#txtNote').val();
		var Property = $('#chkProperty').checkbox('getValue')? '1':'0';
		var IsCurrent = $('#chkIsCurrent').checkbox('getValue')? '1':'0';
		
		if (!KeyWord){
			errinfo = errinfo + "关键词不允许为空!<br>";
		}
		if (!CateID) {
			errinfo = errinfo + "分类不允许为空!<br>";
		}
		if (!PRIID) {
			errinfo = errinfo + "优先级不允许为空!<br>";
		}	
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.KeyRowID;
		inputStr += "^" + KeyWord;
		inputStr += "^" + PRIID;
		inputStr += "^" + Property;
		inputStr += "^" + SuPosID;
		inputStr += "^" + '';
		inputStr += "^" + '';
		inputStr += "^" + $.LOGON.USERID;
		inputStr += "^" + CateID;
		inputStr += "^" + IsCurrent;
		inputStr += "^" + Note;
		
		var flg = $m({
			ClassName:"DHCHAI.IR.CRuleInfSuPos",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
	
		if (parseInt(flg) <= 0) {
			$.messager.alert("失败提示", "更新数据失败,关键词不允许重复!", 'info');
			return;
		}else {
			$HUI.dialog('#SuPosKeyEdit').close();
			obj.KeyRowID ="";
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.gridInfSuPos.reload() ;//刷新当前页
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if ((obj.PosRowID == "")&&(obj.KeyRowID == "")){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		if (obj.PosRowID) {
			$.messager.confirm("删除", "确定删除选中疑似诊断数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.BT.InfSuPos",
						MethodName:"DeleteById",
						aId:obj.PosRowID
					},false);

					if (parseInt(flg) < 0) {
						$.messager.alert("失败提示","删除数据失败!提示码=" + flg, 'info');
						return;
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.PosRowID = "";
						obj.gridInfSuPos.reload() ;//刷新当前页
					}
				} 
			});
		}
		if (obj.KeyRowID) {
			$.messager.confirm("删除", "确定删除选中关键词数据记录?", function (r) {				
				if (r) {				
					var flg = $m({
						ClassName:"DHCHAI.IR.CRuleInfSuPos",
						MethodName:"DeleteById",
						aId:obj.KeyRowID
					},false);

					if (parseInt(flg) < 0) {
						$.messager.alert("失败提示","删除数据失败!提示码=" + flg, 'info');
						return;
					} else {
						$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
						obj.KeyRowID = "";
						obj.gridInfSuPos.reload() ;//刷新当前页
					}
				} 
			});
		}
	}
}