//页面Event
function InitWinEvent(obj){
	//按钮初始化
	$('#winEdit').dialog({
		title: '字典维护',
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
				$HUI.dialog('#winEdit').close();
				obj.gridQCStandDicMatch.loadData([]);
				obj.DicID=""
				obj.gridQCStandDic.clearSelections();
			}
		}]
	});
    obj.LoadEvent = function(args){ 
    
		//添加标准字典
     	$('#btnAdd').on('click', function(){
			obj.layer();
     	});
     	//修改标准字典
     	$('#btnEdit').on('click', function(){
	     	var rd=obj.gridQCStandDic.getSelected();
			obj.layer(rd);
     	});

		//删除标准字典
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
     	//医嘱对照
     	$('#btnMatch').on('click', function(){
			obj.btnMatch_click()
     	});
     	//已对照
     	$('#btnFin').on('click', function(){
			obj.btnQryMatch_click("Y")
     	});
     	//未对照
     	$('#btnPend').on('click', function(){
			obj.btnQryMatch_click("N")
     	});
     	//全部
     	$('#btnAll').on('click', function(){
			obj.btnQryMatch_click("")
     	});
     	//自动匹配
     	$('#btnSyn').on('click', function(){
			obj.btnSyn_click()
     	});
     	//保存值域关键字信息
     	$('#btnSaveKey').on('click', function(){
			obj.btnSaveKey_click()
     	});
     	//保存表字段信息
     	$('#btnSaveTable').on('click', function(){
			obj.btnSaveTable_click()
     	});
     	//保存检验关联信息
     	$('#btnLisSave').on('click', function(){
			obj.btnLisSave_click()
     	});
	//标准字典别名维护按钮事件
     	//添加
     	$('#btnAddA').on('click', function(){
			obj.addNewRule();
     	});
     	//保存
		$('#btnSaveA').on('click', function(){
	     	obj.btnSaveA_click();
     	});
		//删除
		$('#btnDeleteA').on('click', function(){
	     	obj.btnDeleteA_click();
     	});
     }
	obj.gridQCStandDic_onSelect = function (rd){
		Common_SetValue('OrderKey',"")
		if(rd.RowID == obj.DicID) {
			obj.DicID=""
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridQCStandDic.clearSelections();
			obj.LoadStandDicMatch('',"") ;
		}else{
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
			//加载对照信息
			obj.DicID=rd.RowID
			if (obj.gridQCStandDicMatch.getChecked().length>0) {
				obj.PreventUnAC=1
				obj.gridQCStandDicMatch.clearChecked();				
			}
			obj.LoadStandDicMatch('','Y');		
			//加载值域关键字信息
			var KeyStr=$m({
				ClassName:'DHCMA.CPW.SD.Stand.KeyInfo',
				MethodName:'GetKeyStrByDic',
				aDicID:rd.RowID
			},false)
			Common_SetValue('DicKey',KeyStr.split('^')[0]);
			Common_SetValue('DicFilter',KeyStr.split('^')[1]);
			//加载表信息
			var TableStr=$m({
				ClassName:'DHCMA.CPW.SD.Stand.TableInfo',
				MethodName:'GetTableStrByDic',
				aDicID:rd.RowID
			},false)
			Common_SetValue('Table',TableStr.split('^')[0]);
			Common_SetValue('TableField',TableStr.split('^')[1]);
		}
	}
	obj.btnMatch_click = function() {
		var chkRows=obj.gridQCStandDicMatch.getChecked();
		var orderIDStr=""
		for (var i=0;i<chkRows.length;i++) {
				var tmprow=chkRows[i]
				var orderID=tmprow.RowID
				orderIDStr+=orderID+"^"
		}
		$m({
			ClassName:'DHCMA.CPW.SD.StandSrv.OrderLinkSrv',
			MethodName:'LinkDicOrder',
			aDicID:obj.DicID,
			aOrderStr:orderIDStr	
		},function(flg){
			if (parseInt(flg)<1) {
				$.messager.alert("错误提示", "数据加载错误!", 'info');	
			}
			else{
				$.messager.popover({msg: '刷新对照信息成功！',type:'success',timeout: 1000});
				obj.LoadStandDicMatch('',"") ;//刷新当前页
				}
			})
	}
	obj.btnSyn_click = function() {
		if (!obj.DicID){
			$.messager.alert("错误提示", "请选择左侧字典!", 'info');	
			return
		}
		$m({
			ClassName:'DHCMA.CPW.SD.StandSrv.OrderLinkSrv',
			MethodName:'AutoLinkOrder',
			aDicID:obj.DicID
		},function(flg){
				if (parseInt(flg)<1) {
					$.messager.alert("错误提示", "无自动对照医嘱", 'info');	
				}
				else{
					$.messager.popover({msg: '自动对照医嘱数量：'+flg,type:'success',timeout: 1000});
					}
				})
	}
	obj.btnQryMatch_click = function(Matchflg) {
		//加载对照HIS医嘱项
		obj.LoadStandDicMatch('',Matchflg);
	}
	
	obj.btnSaveKey_click = function() {
		var DicKey=Common_GetValue('DicKey')
		var DicFilter=Common_GetValue('DicFilter')
		if ((DicKey=="")&&(DicFilter=="")) {
			$.messager.alert("错误提示", "关键字信息为空！", 'info');
			return;
		}
		$m({
				ClassName:"DHCMA.CPW.SD.Stand.KeyInfo",
				MethodName:"Update",
				aInputStr:"^"+obj.DicID+"^"+DicKey+"^"+DicFilter
			},function(flg){
				if (parseInt(flg)<1) {
					$.messager.alert("错误提示", "数据保存错误!", 'info');	
				}
				else{
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					}
				})
	}
	obj.btnSaveTable_click = function() {
		var Table=Common_GetValue('Table')
		var TableField=Common_GetValue('TableField')
		if ((Table=="")&&(TableField=="")) {
			$.messager.alert("错误提示", "表取值信息缺失！", 'info');
			return;
		}
		$m({
				ClassName:"DHCMA.CPW.SD.Stand.TableInfo",
				MethodName:"Update",
				aInputStr:"^"+obj.DicID+"^"+Table+"^"+TableField
			},function(flg){
				if (parseInt(flg)<1) {
					$.messager.alert("错误提示", "数据保存错误!", 'info');	
				}
				else{
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					}
				})
	}
	obj.btnLisSave_click=function(row){
		var chkRows=obj.gridLisItemMatch.getChecked();
		var CodeIDStr=""
		for (var i=0;i<chkRows.length;i++) {
				var tmprow=chkRows[i]
				var CodeID=tmprow.RowID
				CodeIDStr+=CodeID+"^"
		}
		$m({
			ClassName:'DHCMA.CPW.SD.StandSrv.LabStandSrv',
			MethodName:'LinkDicTCode',
			aDicID:obj.DicID,
			aTCodeID:CodeIDStr
		},function(flg){
			if (parseInt(flg)<1) {
				$.messager.alert("错误提示", "数据保存错误!", 'info');	
			}
			else{
				$.messager.popover({msg: '操作成功！',type:'success',timeout: 1000});
				obj.gridLisItemMatch.reload({
					ClassName:"DHCMA.CPW.SD.StandSrv.LabStandSrv",
					QueryName:"QryLisItem",
					aDicID:obj.DicID
				});
				}
			})
	}
	obj.btnRisSave_click=function(){ 
		//待调试
	}
	obj.LoadStandDicMatch=function(rd,Matchflg){
		obj.gridQCStandDicMatch.reload({
				ClassName:"DHCMA.CPW.SD.StandSrv.OrderSrv",
				QueryName:"QryHisOrder",
				aSourceID:obj.SourceID,
				aDicID:obj.DicID,
				aOrderAlias:Common_GetValue('OrderKey'),
				aMatchFlg:Matchflg
			})
		
		obj.gridLisItemMatch.load({
			ClassName:"DHCMA.CPW.SD.StandSrv.LabStandSrv",
			QueryName:"QryLisItem",
			aDicID:obj.DicID,
			aOrderAlias:'',
			aMatchFlg:""
		});	
	}	
	
	//配置窗体-初始化
	obj.layer= function(rd){
		if(rd){
			var Code = rd["Code"];
			var Desc = rd["Desc"];
			var Resume = rd["Resume"];
			$('#txtCode').val(Code);
			$('#txtDesc').val(Desc);
			$('#txtResume').val(Resume);
		}else{
			$('#txtCode').val('');
			$('#txtDesc').val('');
			$('#txtResume').val('');
		}
		var left=$("#source").offset().left+45;
		$HUI.dialog('#winEdit').open().window("move",{left:left});
		//$HUI.dialog('#winEdit').open();
	}
	obj.btnSave_click=function(){
		var errinfo = "";
		var Code = $('#txtCode').val();
		var Desc = $('#txtDesc').val();
		var Resume = $('#txtResume').val();
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "描述为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var sourceID=Common_GetValue('source');
		var standDicID=Common_GetValue('standDic');
		if(standDicID==""){
			var inputStr = obj.DicID
			inputStr = inputStr + "^"+ obj.SourceID;
			inputStr = inputStr + "^"+ Code;
			inputStr = inputStr + "^"+ Desc;
			inputStr = inputStr + "^"+ Resume;
			var flg = $m({
				ClassName:"DHCMA.CPW.SD.Stand.Dic",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparete:"^"
			},false);
		}else if(standDicID!=""){
			var inputStr = ""
			inputStr = standDicID;
			inputStr = inputStr + "^"+ obj.DicID;
			inputStr = inputStr + "^"+ Code;
			inputStr = inputStr + "^"+ Desc;
			inputStr = inputStr + "^"+ Resume;
			var flg = $m({
				ClassName:"DHCMA.CPW.SD.Stand.Dicsub",
				MethodName:"Update",
				aInputStr:inputStr,
				aSeparete:"^"
			},false);
		}
		if (parseInt(flg) < 0) {
			$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			return ;
		}else {
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			obj.DicID = "";
			obj.gridQCStandDic.reload() ;//刷新当前页
			obj.gridQCStandDicMatch.loadData([]);
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	}
	obj.btnDelete_click = function(){
		if (obj.DicID	==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "删除后对应所有数据清空，确定删除？", function (r) {
			if (r) {
				if(obj.DicID.indexOf("||")<0)	{
					var flg = $m({
					ClassName:"DHCMA.CPW.SD.Stand.Dic",
					MethodName:"DeleteById",
					aId:obj.DicID
					},false);
				}else{
					var flg = $m({
					ClassName:"DHCMA.CPW.SD.Stand.Dicsub",
					MethodName:"DeleteById",
					aId:obj.DicID
					},false);
				}			
				if (parseInt(flg) < 0) {
					if (parseInt(flg)==-777) {
						$.messager.alert("错误提示","系统参数配置不允许删除！", 'info');
					} else {
						$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					}
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.DicID = "";
					obj.gridQCStandDic.reload() ;//刷新当前页
					obj.gridQCStandDicMatch.loadData([]);
				}
			} 
		});
	}
	//标准字典别名时间
	obj.addNewRule=function(){
		$('#StandAliasGrid').datagrid('appendRow',{RowID:'',QCExpressID:'',QCExpress:'',RuleExpress:'',RuleType:'error',RuleContent:''});
      	editIndex = $('#StandAliasGrid').datagrid('getRows').length - 1;
        $('#StandAliasGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
        $("#btnSaveA").linkbutton('enable');
		$("#btnDeleteA").linkbutton('enable');	
	}
	obj.btnSaveA_click=function(){
		var Editrows=$('#StandAliasGrid').datagrid('getSelections')
		for (var i=0;i<Editrows.length;i++) {
			var rowIndex=$('#StandAliasGrid').datagrid('getRowIndex',Editrows[i])
			$('#StandAliasGrid').datagrid('endEdit',rowIndex)
		}
		var rows=$('#StandAliasGrid').datagrid('getChanges');
		var Err="";
		for (var i=0;i<rows.length;i++) {
			var rec=rows[i]
			var InputStr=rec.RowID
			InputStr+="^"+obj.DicID
			InputStr+="^"+rec.Alias
			$m({
					ClassName:"DHCMA.CPW.SD.Stand.DicAlias",
					MethodName:"Update",
					aInputStr:InputStr
					},function(flg){
						if (flg<0) {
							Err=Err+"第"+(i+1)+"行数据保存错误.<br>"
							}
					}
			)
		}
		
		if (Err!="") {				
				$.messager.alert("错误提示", Err, 'info');
		}else{
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000})	
		}	
		obj.StandAliasGrid.reload();
	}
	obj.btnDeleteA_click=function(){
		var Editrows=$('#StandAliasGrid').datagrid('getSelections');
		for (var i=0;i<Editrows.length;i++) {
			var row=Editrows[i];
			if (row.RowID) {
				$.messager.confirm("删除", "是否删除别名:"+row.Alias, function (r) {	
					if (r) {			
						var flg = $m({
							ClassName:"DHCMA.CPW.SD.Stand.DicAlias",
							MethodName:"DeleteById",
							aId:row.RowID
						},false) 
						if (parseInt(flg) < 0) {
							$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
						}else{
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
							obj.StandAliasGrid.reload();
						}						
					}
				})
			}
		}
		obj.StandAliasGrid.reload();
	}
	obj.ShowAlias = function(aDicID){
		obj.DicID=""
		obj.StandAliasGrid = $HUI.datagrid("#StandAliasGrid",{
			fit:true,
			singleSelect: false,
			autoRowHeight: false,
			striped:true,
			rownumbers:true, 
			loadMsg:'数据加载中...',
		    url:$URL,
		    nowrap:false,
		    queryParams:{
			    ClassName:"DHCMA.CPW.SD.StandSrv.DicSrv",
				QueryName:"QryDicAlias",
				aDicID:aDicID
		    },
			columns:[[
				{field:'Alias',title:'别名',width:'300',
				editor:{
							type:'text'
					}
				}
			]]
			,onClickRow:function(index,rowData){
				$("#btnSaveA").linkbutton('enable');
				$("#btnDeleteA").linkbutton('enable');
				$('#StandAliasGrid').datagrid('selectRow', index).datagrid('beginEdit', index);;
			}
			,onLoadSuccess:function(rowIndex,rowData){
				$("#btnSaveA").linkbutton('disable');
				$("#btnDeleteA").linkbutton('disable');
			}
		});
		$HUI.dialog('#winStandAlias').open();
	}
}