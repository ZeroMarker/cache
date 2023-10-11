//页面Event
function InitWinEvent(obj){
	obj.optionID=""
    obj.LoadEvent = function(args){ 
	    //obj.gridScreeningLoad();
		//添加
     	$('#btnAdd').on('click', function(){
			obj.InitDialog();
     	});
     	//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#ScreeningEdit').close();
     	});
     	
     	//保存
     	$('#btnSave').on('click', function(){
			obj.btnSave_click()
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
     	
     	
     	//添加
     	$('#btnAddItem').on('click', function(){
			obj.addNewRule();
     	});
     	//保存
     	$('#btnSaveItem').on('click', function(){
			obj.btnSaveItem_click()
     	});
     	//删除
		$('#btnDeleteItem').on('click', function(){
	     	obj.btnDeleteItem_click();
     	});
     }
     //窗体初始化
	obj.ScreeningEdit = $('#ScreeningEdit').dialog({
		title:'新增病种指标',
		iconCls:'icon-w-edit',  
		closed: true,
		modal: true,
		isTopZindex:true
	});
	//窗体初始化
	obj.winProEdit = $('#winProEdit').dialog({
		title:'指标绑定',
		iconCls:'icon-w-edit',  
		closed: true,
		modal: true,
		isTopZindex:true,
		onBeforeClose:function(){ //关闭窗口时调用查询方法实现状态更新
			obj.gridScreeningLoad()
		}
	});
     obj.refreshNode = function(node)
		{
			//替换初始化子节点后，不再重新加载子节点，50为病种数
			if ((node.id.indexOf("||")<0)&&(node.children.length<60)) {
				//加载子节点数据				
				var subNodes = [];	
				$(node.target).next().children().children("div.tree-node").each(function(){   
					var tmp = $('#ItemOptions').tree('getNode',this);
					subNodes.push(tmp);
				});
				for(var i=0;i<subNodes.length;i++)
				{
					$('#ItemOptions').tree('remove',subNodes[i].target);
				}
				$cm({
					ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
					QueryName:"QryQCEntityCatTree",
					EntityCat :node.id,
					aActive:1,
					ResultSetType:"array", 
					page:1,    
					rows:9999
				},function(rs){  		
					$('#ItemOptions').tree('append', {
							parent: node.target,
							data: rs
					});
				});	
			}else {

				}
		};

	 //双击弹出编辑事件
	obj.gridScreening_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	obj.InitDialogItem = function(id,title){
		obj.gridQCItemLoad(id)
		$('#txtItemId').val(title)
		$HUI.dialog('#winProEdit').open();
	}
	obj.addNewRule=function(){
		$('#gridQCItem').datagrid('appendRow',{RowID:'',ItemId:'',ItemDesc:'',ItemAbbrev:''});
      	editIndex = $('#gridQCItem').datagrid('getRows').length - 1;
        $('#gridQCItem').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
        $("#btnAddItem").linkbutton('enable');
		$("#btnDeleteItem").linkbutton('enable');
		$('#txtIndexExp2').val(obj.IndexExp)	
	}
	//窗口初始化
	obj.InitDialog = function(rd){
		/*$HUI.combobox('#cboParentid',
	    {
		    defaultFilter:4,
			url:$URL+'?ClassName=DHCMA.CPW.SDS.QCIndexInfoSrv&QueryName=QryQCHeadertype&EntityId='+obj.Entity+'&aType='+obj.radioVal+'&ResultSetType=Array',
			valueField:'RowId',
			textField:'Desc'	  
	    })*/
		if(rd){
			$("#cboType").combobox('enable');
			obj.optionID = rd["ID"];
			var title = rd["title"];
			var field = rd["field"];
			var headertype = rd["headertype"];
			var active = rd["active"];
			var parent = rd["parent"];
			var sort = rd["sort"];
			var type = rd["type"];
			if (rd["ID"]==parent){parent=""}
			Common_SetValue('cboType',type);
			Common_SetValue('cboHeadertype',headertype);
			Common_SetValue('cboParentid',parent);
			$('#txtTitle').val(title);	
			$('#txtEntity').val(obj.EntityDesc);
			$('#txtField').val(field);
			$('#txtSort').val(sort);
			$('#chkIsActive').checkbox('setValue',(active==1 ? true:false));
		}else{
			obj.optionID = "";
			$('#txtTitle').val('');
			$('#txtEntity').val(obj.EntityDesc);
			$('#cboParentid').combobox('clear');
			Common_SetValue('cboHeadertype','');
			Common_SetValue('cboType',obj.radioVal);
			$("#cboType").combobox('disable');
			$('#txtField').val('');
			$('#txtSort').val('');
			$('#chkIsActive').checkbox('setValue','');
		}
		$HUI.dialog('#ScreeningEdit').open();
	}
	
	obj.btnSaveItem_click=function(){
		var Editrows=$('#gridQCItem').datagrid('getSelections')
		for (var i=0;i<Editrows.length;i++) {
			var rowIndex=$('#gridQCItem').datagrid('getRowIndex',Editrows[i])
			$('#gridQCItem').datagrid('endEdit',rowIndex)
		}
		var rows=$('#gridQCItem').datagrid('getChanges');
		var IndexExp=$('#txtIndexExp2').val()
		if(!IndexExp){
			$.messager.alert("错误提示", "取值表达式必填", 'info');
			obj.gridQCItemLoad(obj.optionID)
			return
		}
		var Err="";
		for (var i=0;i<rows.length;i++) {
			var rec=rows[i]
			var InputStr=obj.optionID
			InputStr+="^"+rec.RowID
			InputStr+="^"+rec.ItemId
			InputStr+="^"+rec.ItemAbbrev
			if(!obj.optionID){
				$.messager.alert("错误提示", "未选中末级指标", 'info');
				return
			}
			if(!rec.ItemId){
				$.messager.alert("错误提示", "未选中统计指标", 'info');
				return
			}
			if(!rec.ItemAbbrev){
				$.messager.alert("错误提示", "未赋值指标代码", 'info');
				return
			}
			$m({
				ClassName:"DHCMA.CPW.SD.IndexItem",
				MethodName:"Update",
				aInputStr:InputStr
				},function(flg){
					if (flg<=0) {
						Err=Err+"第"+(i+1)+"行数据保存错误.<br>"
					}
			})
		}
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.IndexInfo",
			MethodName:"UpIndexExp",
			aInputStr:obj.optionID+"^"+IndexExp,
			aSeparete:"^"
		},false);
		if (Err!="") {				
			$.messager.alert("错误提示", Err, 'info');
		}else{
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000})
			obj.gridQCItemLoad(obj.optionID)	
		}	
		obj.gridQCItemLoad(obj.optionID)
	}
	//删除
	obj.btnDeleteItem_click=function(){
		if(!obj.optionID){
				$.messager.alert("错误提示", "未选中末级指标", 'info');
				return
			}
		var Editrows=$('#gridQCItem').datagrid('getSelections');
		for (var i=0;i<Editrows.length;i++) {
			var row=Editrows[i];
			if (row.RowID) {
				$.messager.confirm("删除", "是否删除:"+row.ItemDesc, function (r) {	
					if (r) {			
						var flg = $m({
							ClassName:"DHCMA.CPW.SD.IndexItem",
							MethodName:"DeleteById",
							aId:obj.optionID+"||"+row.RowID
						},false)
						if (flg==0) {
							$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000})
						} 
						obj.gridQCItemLoad(obj.optionID);
					}
				})
			}
		}
		obj.gridQCItemLoad(obj.optionID);
	}
	//保存
	obj.btnSave_click = function(flg){
		var errinfo = "";
		var Title = $.trim($('#txtTitle').val());
		var Parentid = $('#cboParentid').combobox('getValue');
		var Headertype = $('#cboHeadertype').combobox('getValue');
		var type = $('#cboType').combobox('getValue');
		var Field = $.trim($('#txtField').val());
		var Sort = $.trim($('#txtSort').val());
		var IsActive = $('#chkIsActive').checkbox('getValue')? '1':'0';
		if(Field==undefined) Field=""
		if(Parentid==undefined) Parentid=""
		if(Sort==undefined) Sort=""
		if(Title==undefined) Title=""
		if(Headertype==undefined) Headertype=""
		if(type==undefined) type=""
		if (!Headertype){
			errinfo = errinfo + "指标分类为空!<br>";
		}
		if (!type){
			errinfo = errinfo + "指标类型为空!<br>";
		}	
		if (!Sort){
			errinfo = errinfo + "序号为空!<br>";
		}
		if (!Field&&Headertype==0){
			errinfo = errinfo + "末级指标指标字段不能为空!<br>";
		}
		if ((Headertype==0)&&((Field.indexOf("field")<0)||(Field=="field"))){
			errinfo = errinfo + "指标字段必须以field+数字且不能重复!<br>";
			}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		
		var inputStr = obj.optionID;
		inputStr = inputStr + "^" + Title; 
		inputStr = inputStr + "^" + obj.Entity; 
		inputStr = inputStr + "^" + Parentid;   
		inputStr = inputStr + "^" + Headertype;  
		inputStr = inputStr + "^" + Field;       
		inputStr = inputStr + "^" + Sort;    
		inputStr = inputStr + "^" + IsActive;
		inputStr = inputStr + "^" + type;
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.IndexInfo",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:"^"
		},false);
		if (parseInt(flg) == "-777") {
			$.messager.alert("错误提示", "指标字段重复，请重新填写", 'info');
			return;
		}
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
		if (obj.optionID == ""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.SD.IndexInfo",
					MethodName:"DeleteById",
					aId:obj.optionID
				},false);

				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');
					return;
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.optionID = "";
					$("#SuspScreening").datagrid('clearSelections');
					obj.gridScreeningLoad();
				}
			} 
		});
	}
	
	//单击选中事件
	obj.gridScreening_onSelect = function (){
		var rowData = obj.gridScreening.getSelected();
		if (rowData["ID"] == obj.optionID) {
			obj.optionID="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridScreening.clearSelections();  //清除选中行
		} else {
			obj.optionID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
	}
	obj.gridScreeningLoad = function(aAlias){
		$cm ({
			ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
			QueryName:"QryScreenInfo",
			ResultSetType:"array",
			EntityId:obj.Entity,
			aType:obj.radioVal,
			page:1,
			rows:9999
		},function(rows){
			obj.gridScreening.loadData({"rows":rows});
		});
	}
	obj.gridQCItemLoad = function(ID){
		$cm ({
			ClassName:"DHCMA.CPW.SDS.QCIndexInfoSrv",
			QueryName:"QryQCItemInfo",
			aIinkItem:ID,
			ResultSetType:"array",
			page:1,
			rows:9999
		},function(rows){
			obj.gridQCItem.loadData({"rows":rows});
			obj.IndexExp=""
			if(rows.length){
				obj.IndexExp=rows[0].indexExp
			}
			$('#txtIndexExp2').val(obj.IndexExp)
		});
	}
}