//页面Event
function InitHISUIWinEvent(obj){
	//CheckSpecificKey();
	//取表单对象ParamID
	
	//提交后台保存
	obj.saveToSrv=function()
	{
		var sID = $("#itemOrdID").val();
		var OrdTypeDr = $("#cboOrdTypeDr").combobox("getValue");
		var OrdMastID = $("#txtOrdMastIDH").val();
		var OrdGeneID  =$("#itemOrdGeneID").val();
		var OrdPriorityID   = $("#cboOrdPriorityID").combobox("getValue");
		var OrdQty = $("#txtOrdQty").val();
		var OrdFreqID = $("#txtOrdFreqIDH").val();
		var OrdDuratID = $("#txtOrdDuratIDH").val();
		var OrdInstrucID = $("#txtOrdInstrucIDH").val();
		var OrdDoseQty = $("#txtOrdDoseQty").val();
		var OrdUOMID = $("#cboOrdUOMID").combobox("getValue");
		var OrdNote = $("#txtOrdNote").val();
		var OrdChkPosID = $("#txtOrdPos").val();
		var OrdLnkOrdDr =$("#txtOrdLnkOrdDr").val(); 
		var OrdIsDefault =$("#txtOrdIsDefault").val(); 
		var OrdIsFluInfu =$("#txtOrdIsFluInfu").val(); 
		var BTIsActive =  $("#txtBTIsActive").val(); 
		var OrdUseDays = $("#txtOrdUseDays").val();
		var OrdQtyUOMID = $("#txtOrdQtyUOMID").val(); 
		var selData = $('#gridItemOrd').datagrid('getSelected');
		var OrdOID = "";
		if (selData!=undefined && selData!=null) var SeqCode=selData.SeqCode;
		else var SeqCode="";	
				
		if(OrdMastID=="")
		{
			$.messager.popover({msg: '名称不可以为空！',type:'error'});
			return false;
		}
		if(OrdPriorityID=="")
		{
			$.messager.popover({msg: '医嘱类型不可以为空！',type:'error'});
			return false;
		}
		if(OrdTypeDr=="")
		{
			$.messager.popover({msg: '分类不可以为空！',type:'error'});
			return false;
		}
		if((obj.ARCICOrderType=="L")||(obj.ARCICOrderType=="X"))	//检验、检查医嘱
		{
			var TypeDesc=$("#cboOrdPriorityID").combobox("getText");
			if(TypeDesc!="临时医嘱") {
				$.messager.alert("提示","检查或检验医嘱只能是临时医嘱！");
				return false;
			}
		}
		var InputStr = ParamID+"^"+sID;
		InputStr += "^" + OrdTypeDr;
		InputStr += "^" + OrdMastID;
		InputStr += "^" + OrdGeneID;
		InputStr += "^" + OrdPriorityID;
		InputStr += "^" + OrdQty;
		InputStr += "^" + OrdFreqID;
		InputStr += "^" + OrdDuratID;
		InputStr += "^" + OrdInstrucID;
		InputStr += "^" + OrdDoseQty;
		InputStr += "^" + OrdUOMID;
		InputStr += "^" + OrdNote;
		InputStr += "^" + OrdChkPosID;
		InputStr += "^" + OrdLnkOrdDr;
		InputStr += "^" + OrdIsDefault;
		InputStr += "^" + OrdIsFluInfu;		
		InputStr += "^" + BTIsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + session['DHCMA.USERID'];
		InputStr += "^" + OrdOID;
		InputStr += "^" + SeqCode;
		InputStr += "^";
		InputStr += "^" + OrdUseDays;
		InputStr += "^" + OrdQtyUOMID;
		//同步调用
		var data = $.cm({ClassName:"DHCMA.CPW.BT.PathFormOrd",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^",
				"aUserID":session["DHCMA.USERID"]
			},false);
		if(parseInt(data)<0){
			$.messager.popover({msg: '失败！',type:'error'});
			return false;
		}else{		
			obj.clearData();
			obj.gridItemOrd.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItemOrd",
				aPathFormEpItemDr:ParamID
			}); 
			obj.IsCheckIndex=-1
			$.messager.popover({msg: '成功！',type:'success'});
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
			$("#addIcon").linkbutton("enable");			
		}
		return true;
	};

	obj.OrdMastSelect=function(rowData)
	{
		//取医嘱项相关信息赋值
		//691||1^R^1^1^17^支^63^1天^4^Qd^4^注射^46^注射用无菌粉末^632^注射用奥美拉唑钠^[40mg]^17^支^注射用奥美拉唑钠[利君][40mg]
		$("#txtOrdMastIDH").val(rowData.ArcimID);
		var rstData = $cm({ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",MethodName:"GetArcimInfoById",aArcimID:rowData.ArcimID,aHospID:CurrHosp,dataType:'text'},false);
		var rstArr = rstData.split("^");		
		
		//剂量单位赋值	
		obj.cboOrdUOMID = $HUI.combobox("#cboOrdUOMID",{
			url:$URL+"?ClassName=DHCMA.CPW.BTS.LinkArcimSrv&QueryName=QryDoseUomByArcim&aArcimID="+rowData.ArcimID+"&aHospID="+CurrHosp+"&ResultSetType=array",
			valueField:'DoseUomID',
			textField:'DoseUomDesc'
		});
		
		//频次
		$("#cboOrdFreqID").val(rstArr[9]);
		$("#cboOrdDuratID").val(rstArr[7]);
		$("#cboOrdInstrucID").val(rstArr[11]);
		$("#txtOrdFreqIDH").val(rstArr[8]);
		$("#txtOrdDuratIDH").val(rstArr[6]);
		$("#txtOrdInstrucIDH").val(rstArr[10]);
		
		$("#itemOrdGeneID").val(rstArr[14]);  //通用名ID
		$("#txtOrdDoseQty").val(rstArr[3]);  //剂量
		$('#cboOrdUOMID').combobox('setValue',rstArr[4]);
		$('#cboOrdUOMID').combobox('setText',rstArr[5]);
		$("#txtOrdQtyUOMID").val(rstArr[17]);
		$("#txtOrdQtyUOMDesc").val(rstArr[18]); //数量单位 dsp
		obj.ARCICOrderType=rstArr[20];	//医嘱类型
	};

	//删除按钮处理事件
	obj.delHandler= function(){
		var selData = $('#gridItemOrd').datagrid('getSelected');
		if(selData){
			if (selData.ID){
				$.messager.confirm("确认","确定删除?",function(r){
					if(r){
						$.cm({ClassName:'DHCMA.CPW.BT.PathFormOrd',MethodName:'DeleteById','aId':ParamID+"||"+selData.ID,'aUserID':session["DHCMA.USERID"]},function(data){
							//debugger;
							if(parseInt(data)<0){
								$.messager.popover({msg: '失败！',type:'error'});
								$("#addIcon").linkbutton("enable");
								$("#editIcon").linkbutton("disable");
								$("#delIcon").linkbutton("disable");
							}else{							
								//重新加载datagrid的数据  
								obj.clearData();
								obj.gridItemOrd.load({
									ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
									QueryName:"QryPathFormEpItemOrd",
									aPathFormEpItemDr:ParamID
								}); 
								$.messager.popover({msg: '成功！',type:'success'});
								$("#addIcon").linkbutton("enable");
								$("#editIcon").linkbutton("disable");
								$("#delIcon").linkbutton("disable");	
							}
						});
					}
				});
			}
		}
		else
		{
			$.messager.alert("提示","请选中需要删除的条目！");
			return false;
		}
		
	};
	
	obj.Win_close = function(){
		if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
	}

	obj.CboSelectByText = function(idName,selTxt){
		var rstData = $('#'+idName).combobox('getData');
		var selID = "";
		for(var i=0;i<rstData.length;i++)
		{
			if(selID=="")
			{				
				var objTmp = rstData[i];
				if(objTmp.BTCode ==selTxt)
				{
					selID = objTmp.BTID;
				}
			}
		}
		if(selID!="")
			$('#'+idName).combobox('setValue',selID);
	};

	//事件绑定
	obj.LoadEvents = function(arguments){	
		
		//根据配置决定是否允许修改关联医嘱
		obj.CheckModifyConfig();
		
		$("#addIcon").on('click',function(){
			// 添加一行
			$("#txtBTIsActive").val("1");
			$("#txtOrdIsFluInfu").val("1")	//默认主医嘱
			$("#itemOrdID").val("");
			obj.saveToSrv();
			$("#saveSeq").linkbutton("enable");
		});
		$("#editIcon").on('click',function(){
			obj.saveToSrv();
		});	
		$("#delIcon").on('click',function(){
			obj.delHandler();
		});	
		$("#btnClose").on('click',function(){			
			if(top.$ && top.$("#WinModalEasyUI").length>0) top.$("#WinModalEasyUI").window("close");
		});	
		$("#btnAddPos").on('click',function(){
			var OrdMastID = $("#txtOrdMastIDH").val();
			if(OrdMastID==""){
				$.messager.alert("提示","请先选择医嘱！");
				return;
			}
			//是否是检查医嘱
			var isExamOrder = $.cm({ClassName:"DHCMA.CPW.IO.FromDoc",MethodName:"IsExamOrder",
				"aArcimID":OrdMastID
			},false);
			if (parseInt(isExamOrder)!=1){
				$.messager.alert("提示","只允许给检查医嘱添加部位！");
				return;
			}
			
			//var row = $("#gridItemOrd").datagrid("getSelected");
			var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=*";
			if($("#txtOrdPos").val()){
				var path="dhcapp.appreppartwin.csp?itmmastid="+OrdMastID+"&selOrdBodyPartStr=" + $("#txtOrdPos").val().split("||")[1]+"*"+$("#txtOrdPos").val().split("||")[2];
			}
			websys_showModal({
				url		:path,
				title	:'添加检查部位',
				iconCls	:'icon-w-import',  
				closable:true,
				width	:1200,
				height	:500,
				originWindow:window,
				CallBackFunc:function(ret){
					if((ret!="")&&(ret!=undefined)){
						var arrPos=ret.split("^")
						var strPos=arrPos[0]+"||"+arrPos[1]+"||"+arrPos[2];
						$("#txtOrdPos").val(strPos);
						$("#txtOrdPosShow").val(arrPos[0]);
					}
				}
			})
		});
		$('#moveUp').on('click', function(){
			obj.moveItemUp();
		});
		$('#moveDown').on('click', function(){
			obj.moveItemDown();
		});
		$('#saveSeq').on('click', function(){
			obj.saveSeq();
		});
		$("#copyIcon").on('click',function(){
			obj.OpenWinCopy(); 
		})
		
		$("#admitTip").on('click',function(){
			$HUI.dialog("#winAdmitTipInfo").open();	
		})
		
		//默认选择第一条科室
		//$('#ulEpMX li:first-child').click();
		$("body").layout();
		//$("#layoutId").layout("resize");
		//$.parser.parse($('#dictDlg').parent());
		$.parser.parse($("body"));
		$("#divBase").panel({title: "正在编辑的项目："+ParamDesc+"<span style=\"float:right;padding: 0 8px;\">当前阶段参考天数：<b>"+obj.CurrEpDays+"天</b></span>"})
		//$("body").layout('collapse','west');
	};

	obj.clearData = function()
	{
		obj.CboSelectByText("cboOrdTypeDr","yzx");
		$("#itemOrdID").val("");
		$("#txtOrdMastIDH").val("");
		$("#txtOrdMastID").val("");
		$("#itemOrdGeneID").val("");
		$("#cboOrdPriorityID").combobox("setValue","");
		$("#txtOrdQty").val("");
		$("#txtOrdQtyUOMID").val("");
		$("#txtOrdQtyUOMDesc").val("");
		$("#cboOrdFreqID").val("");
		$("#cboOrdDuratID").val("");
		$("#cboOrdInstrucID").val("");
		$("#txtOrdFreqIDH").val("");
		$("#txtOrdDuratIDH").val("");
		$("#txtOrdInstrucIDH").val("");
		$("#txtOrdDoseQty").val("");
		$("#cboOrdUOMID").combobox("setValue","");
		$("#txtOrdNote").val("");
		$("#txtOrdLnkOrdDr").val(""); 
		$("#txtOrdPos").val("");
		$("#txtOrdPosShow").val("");
		$("#txtOrdUseDays").val("");
		obj.curFormOrdID="";
		obj.isCNMedItem=0;
		obj.isLongOrdType=0; 
	};

	obj.selRowDataView = function()
	{		
		var selData = $('#gridItemOrd').datagrid('getSelected');  //['MRTypeDrDesc']
		var pDt = {ArcimID:selData["OrdMastID"]};
		obj.OrdMastSelect(pDt);
		$("#cboOrdTypeDr").combobox("setValue",selData["OrdTypeDr"]);
		$("#itemOrdID").val(selData["ID"]);
		$("#txtOrdMastIDH").val(selData["OrdMastID"]);
		$("#txtOrdMastID").val(selData["OrdMastIDDesc"]).validatebox("validate");
		$("#itemOrdGeneID").val(selData["OrdGeneID"]);
		$("#cboOrdPriorityID").combobox("select",selData["OrdPriorityID"]);
		$("#txtOrdQty").val(selData["OrdQty"]);
		$("#cboOrdFreqID").val(selData["OrdFreqIDDesc"]);
		$("#cboOrdDuratID").val(selData["OrdDuratIDDesc"]);
		$("#cboOrdInstrucID").val(selData["OrdInstrucIDDesc"]);
		$("#txtOrdFreqIDH").val(selData["OrdFreqID"]);
		$("#txtOrdDuratIDH").val(selData["OrdDuratID"]);
		$("#txtOrdInstrucIDH").val(selData["OrdInstrucID"]);
		$("#txtOrdDoseQty").val(selData["OrdDoseQty"]);
		if(selData["OrdUOMID"]!=undefined){
			$("#cboOrdUOMID").combobox("select",selData["OrdUOMID"]);
			$("#cboOrdUOMID").combobox("setText",selData["OrdUOMIDDesc"]);  
		}else{
			$("#cboOrdUOMID").combobox("setValue","");
			}
		$("#txtOrdNote").val(selData["OrdNote"]);
		$("#txtOrdLnkOrdDr").val(selData["OrdLnkOrdDr"]); 
		$("#txtOrdPos").val(selData["OrdChkPosID"]);
		if ((selData["OrdChkPosID"]!="")&&(selData["OrdChkPosID"]!=undefined)){
			$("#txtOrdPosShow").val(selData["OrdChkPosID"].split("||")[0]);	
		}else{
			$("#txtOrdPosShow").val("");	
		}
		$("#txtOrdIsDefault").val(selData["OrdIsDefault"]=="否"?"0":"1");
		$("#txtOrdIsFluInfu").val(selData["OrdIsFluInfu"]=="否"?"0":"1");
		$("#txtBTIsActive").val(selData["OrdIsActive"]=="否"?"0":"1");
		$("#txtOrdUseDays").val(selData["OrdUseDays"]);
	};

	obj.saveToEntiy = function(aInputStr){
		var rstData = $m({ClassName:"DHCMA.CPW.BT.PathFormOrd",MethodName:"UpdateCVal",aInputStr:aInputStr,aSeparete:"^",aUserID:session["DHCMA.USERID"]},false);
		$.messager.alert("提示","更新完成！");
	};

	// 上移医嘱项
	obj.moveItemUp = function(){
		var selectedRow = $("#gridItemOrd").datagrid("getSelected");
		var selectedRowIndex = $("#gridItemOrd").datagrid("getRowIndex", selectedRow);
		if (selectedRowIndex == 0) {
			$("#moveUp").linkbutton("disable");
			return;
		}

		// 移动顺序的本质：先删除当前行，在插入上一行
		$("#gridItemOrd").datagrid("deleteRow", selectedRowIndex);
		$("#gridItemOrd").datagrid("insertRow", {
			index	: selectedRowIndex-1,
			row		: selectedRow
		});
		obj.isModified = true;
		$("#gridItemOrd").datagrid("selectRow", selectedRowIndex-1);
		if (obj.isModified) {
			$("#saveSeq").linkbutton("enable");
		}
	};

	// 下移医嘱项
	obj.moveItemDown = function(){
		var selectedRow = $("#gridItemOrd").datagrid("getSelected");
		var selectedRowIndex = $("#gridItemOrd").datagrid("getRowIndex", selectedRow);
		if ((selectedRowIndex == obj.gridItmCnt-1) || (selectedRowIndex == $('#gridItemOrd').datagrid('options').pageSize-1)) {
			$("#moveDown").linkbutton("disable");
			return;
		}

		// 移动顺序的本质：先删除当前行，在插入下一行
		$("#gridItemOrd").datagrid("deleteRow", selectedRowIndex);
		$("#gridItemOrd").datagrid("insertRow", {
			index	: selectedRowIndex+1,
			row		: selectedRow
		});
		obj.isModified = true;
		$("#gridItemOrd").datagrid("selectRow", selectedRowIndex+1);
		if (obj.isModified) {
			$("#saveSeq").linkbutton("enable");
		}
	};

	// 保存医嘱项顺序
	obj.saveSeq = function () {
		var rows = $("#gridItemOrd").datagrid("getRows");
		if (rows.length == 0) return;

		var strItmList = "", curIndex = 0;
		rows.forEach(function (row) {
			var curIndex = $("#gridItemOrd").datagrid("getRowIndex", row) + 1;
			
			// -用来分隔每一条数据，^用来分隔每条数据的数据项
			strItmList = strItmList + curIndex;
			strItmList = strItmList + "^" + row.xID;
			strItmList = strItmList + "-";
		});

		$cm({
			ClassName	: 'DHCMA.CPW.BT.PathFormOrd',
			MethodName	: 'UpdateSeqCode',
			aInputStr	: strItmList,
			aUserID		: session["DHCMA.USERID"]
		}, function (ret) {
			//console.log(ret);
			if (ret > 0) {
				$("#saveSeq").linkbutton("disable");
				obj.isModified = false;
				$.messager.popover({msg: '保存成功',type:'success',timeout: 2000});
			}else{
				$.messager.popover({msg: '保存失败！',type:'error',timeout: 2000});
			}
		});
	}
	
	//复制关联医嘱事件调用
	obj.OpenWinCopy = function(){
		websys_showModal({
			url:"./dhcma.cpw.bt.itemordcopy.csp?1=1&ParamID="+ParamID+"&CurrHosp="+CurrHosp, //"./dhcma.cpw.bt.pathform.csp", //
			title:"复制医嘱",
			iconCls:'icon-w-import',  
			closable:true,
			originWindow:window,
			width:"95%",
			height:"90%",
			onClose:function(){
				obj.gridItemOrd.load({
					ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
					QueryName:"QryPathFormEpItemOrd",
					aPathFormEpItemDr:ParamID
				});	
			}
		});	
	}
	
	// 检查是否允许发布后再修改配置
	obj.CheckModifyConfig = function() {
		if (IsOpen=="0") return;				// 未发布路径不进行控制
		$m({
			ClassName	: 'DHCMA.Util.BT.Config',
			MethodName	: 'GetValueByCode',
			aCode		: "CPWIsForbitModifyOrder",
			aHospID		: session['DHCMA.HOSPID']
		}, function (ret) {
			obj.cfgModifyVal = ret;
			if (ret == "Y") {
				$("input").attr("disabled", "disabled");
				$("#cboOrdTypeDr,#cboOrdPriorityID,#cboOrdUOMID").combobox('disable');
				$("#addIcon,#editIcon,#delIcon,#copyIcon,#btnAddPos").linkbutton("disable");
				
			}
		});	
	}
}

