//页面Event
function InitSuspScreeningWinEvent(obj){	
    
    obj.LoadEvent = function(args){ 
        obj.gridScreeningLoad();
	    //保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#ScreeningEdit').close();
     	});
		
	    //添加
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		//编辑
		$('#btnEdit').on('click', function(){
			var rd = obj.gridScreening.getSelected();
			obj.InitDialog(rd);
		});
		//删除
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});	
		//检索框
		$('#searchbox').searchbox({ 
			searcher:function(value,name){ 
				obj.gridScreeningLoad(value);
			}	
		});
		//同步传染病字典别名
		$('#btnSync').on('click', function(){
			obj.SyncInfectionAlias();
		});
	}
	
		
	//弹出加载层
	function loadingWindow2() {	
	    var left = ($(window).outerWidth(true)) / 2; 
		var top = ($(window).height() - 35) / 2; 
		var height = $(window).height() * 2; 
 		$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: height ,opacity: .7,'z-index': 5000}).appendTo("#divScreen"); 
 		$("<div class=\"datagrid-mask-msg\"></div>").html("数据同步中,请稍候...").appendTo("#divScreen").css({ display: "block", left: left, top: top }); 
	}

	//同步传染病字典别名
	obj.SyncInfectionAlias = function(){
		loadingWindow2();
		window.setTimeout(function () {			
			var Count= $m ({
				ClassName:'DHCMed.EPDService.SuspScreeningSrv',
				MethodName:'SyncInfectionAlias'
			},false);
			
			if (Count>0) {
				obj.gridScreeningLoad();
			}
			$.messager.popover({msg: '同步完成，共'+Count+'项',type:'success',timeout: 1000});
			$(".datagrid-mask").remove();
	   		$(".datagrid-mask-msg").remove(); 
		}, 100); 		
	}
	
	//窗体初始化
	obj.ScreeningEdit = $('#ScreeningEdit').dialog({
		title:'疑似筛查条件维护',
		iconCls:'icon-w-edit',  
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	//保存
	obj.btnSave_click = function(){
		var errinfo = "";
		var InfectID = $('#cboInfect').combobox('getValue');
		var Condition = $.trim($('#txtCondition').val());
		var Note = $('#txtNote').val();
		var TypeID = $('#cboType').combobox('getValue');
		var IncludeKey = $('#txtIncludeKey').val();
		var ExcludeKeys = $('#txtExcludeKeys').val();
		var LisItemDrs = $('#cbgLisItems').combogrid('getValues');
		var LisItems = $('#cbgLisItems').combogrid('getText');	
		var LisLogic = $('#txtLisLogic').val();
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		var UserID  = session['LOGON.USERID'];
		var UserName  = session['LOGON.USERNAME'];
	
		if (!InfectID){
			errinfo = errinfo + "疑似诊断为空!<br>";
		}
		if (!Condition) {
			errinfo = errinfo + "筛查条件为空!<br>";
		}
		if (!TypeID) {
			errinfo = errinfo + "筛查类型为空!<br>";
		}	
		
		if ((TypeID=='L')&&(!LisItemDrs)){
			errinfo = errinfo + "筛查类型为“检验”,检验项目不允许为空!<br>";
		}
		if ((TypeID=='L')&&(LisItems.indexOf(",")>0)&&((!LisLogic)||(LisLogic!="&&"))){
			errinfo = errinfo + "多个检验项目，逻辑运算使用“&&”关系!<br>";
		}
		if ((TypeID!='L')&&(!IncludeKey)){
			errinfo = errinfo + "筛查类型非“检验”时,包含关键词不允许为空!<br>";
		}
		
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + InfectID;   
		inputStr = inputStr + CHR_1 + Condition;  
		inputStr = inputStr + CHR_1 + Note;       
		inputStr = inputStr + CHR_1 + TypeID;    
		inputStr = inputStr + CHR_1 + IncludeKey; 
		inputStr = inputStr + CHR_1 + ExcludeKeys;
		inputStr = inputStr + CHR_1 + LisItemDrs;   
		inputStr = inputStr + CHR_1 + LisLogic;  
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + UserName;
		var flg = $m({
			ClassName:"DHCMed.EPD.SuspScreening",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
		},false);
		
		if (parseInt(flg) <= 0) {
			$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			return;
		}else {
			$HUI.dialog('#ScreeningEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$("#SuspScreening").datagrid('clearSelections');
			obj.gridScreeningLoad();
		}
	}
	//删除 
	obj.btnDelete_click = function(){
		if (obj.RecRowID == ""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMed.EPD.SuspScreening",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);

				if (parseInt(flg) < 0) {
					if (parseInt(flg)=='-777') {
						$.messager.alert("错误提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					$("#SuspScreening").datagrid('clearSelections');
					obj.gridScreeningLoad();
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridScreening_onSelect = function (){
		var rowData = obj.gridScreening.getSelected();
	
		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			
			obj.gridScreening.clearSelections();  //清除选中行
		} else {
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}	
	
    //双击弹出编辑事件
	obj.gridScreening_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	
	//窗口初始化
	obj.InitDialog = function(rd){
		if(rd){
			obj.RecRowID = rd["ID"];
			var InfectID = rd["InfectID"];
			var Infection = rd["InfectDesc"];
			var Condition = rd["Condition"];
			var Note = rd["Note"];
			var TypeID = rd["Type"];
			var IncludeKey = rd["IncludeKey"];
			var ExcludeKeys = rd["ExcludeKeys"];
			var LisItemDrs = rd["LisItemDrs"];
			var LisItems = rd["LisItems"];
			var LisLogic = rd["LisLogic"];
			var IsActive = rd["IsActive"];
			
			$('#cboInfect').combobox('setValue',InfectID);
			$('#cboInfect').combobox('setText',Infection);
			$('#cboType').combobox('setValue',TypeID);
			$('#txtCondition').val(Condition).validatebox("validate");;
			$('#txtNote').val(Note);	
			$('#txtIncludeKey').val(IncludeKey);
			$('#txtExcludeKeys').val(ExcludeKeys);
			$('#cbgLisItems').combogrid('setValue',LisItemDrs);
			$('#cbgLisItems').combogrid('setText',LisItems);
			$('#txtLisLogic').val(LisLogic);
			$('#chkIsActive').checkbox('setValue',(IsActive==1 ? true:false));
	
		}else{
			obj.RecRowID = "";
			$('#cboInfect').combobox('clear');
			$('#cboType').combobox('clear');
			$('#txtCondition').val('');
			$('#txtNote').val('');
			$('#txtIncludeKey').val('');
			$('#txtExcludeKeys').val('');
			$('#cbgLisItems').combogrid('clear');
			$('#txtLisLogic').val('');
			$('#chkIsActive').checkbox('setValue','');
		}
		$HUI.dialog('#ScreeningEdit').open();
	}
	
	obj.gridScreeningLoad = function(aAlias){
		$cm ({
			ClassName:"DHCMed.EPDService.SuspScreeningSrv",
			QueryName:"QryScreenInfo",
			ResultSetType:"array",
			aAlias:aAlias,
			page:1,
			rows:9999
		},function(rows){
			obj.gridScreening.loadData({"rows":rows});
		});
	}
}