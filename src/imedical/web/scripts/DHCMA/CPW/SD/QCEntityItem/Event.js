//页面Event
function InitWinEvent(obj){
	obj.RecRowID="",obj.ItemID=""
	$('#winQCEntityItem').dialog({
		title: '质控项目维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});	
	$('#winQCItemRule').dialog({
		title: '项目校验规则维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		isTopZindex:true
		
	});
    obj.LoadEvent = function(args){ 
    	//选择项目分类
    	$('#BTExpress').combobox({
			onSelect: function(r){
				$('#GetDataParam').combobox('clear');//清空选中项
				if (r.BTCode=="BaseInfo") {
					$HUI.combobox("#GetDataParam",{
						url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryClassProperty&ResultSetType=Array&aClassName=DHCMA.Util.EPx.Episode',
						valueField:'PropertyName',
						textField:'PropertyName',	
					})
				}else if (r.BTCode=="ORInfo") {
					$HUI.combobox("#GetDataParam",{
						url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryClassProperty&ResultSetType=Array&aClassName=DHCMA.CPW.SD.Data.Operation',
						valueField:'PropertyName',
						textField:'PropertyName',	
					})
				}else{
					$('#GetDataParam').combobox('loadData', {});
				}
			}
		});
     	
		//添加
     	$('#btnAdd').on('click', function(){
			obj.layer()
     	});
     	
		//编辑
		$('#btnEdit').on('click', function(){
			var rd=obj.gridQCEntityItem.getSelected()
			if (rd) {
				obj.layer(rd);
			}
			else {
				$.messager.alert("提示", "请选中行，再行修改！", 'info');
				return;
			}		
     	});
		//删除
		$('#btnDelete').on('click', function(){
	     	obj.btnDelete_click();
     	});
     	
     	//保存
		$('#btnSave').on('click', function(){
	     	obj.btnSave_click();
     	});
		//关闭
		$('#btnClose').on('click', function(){
	     	$HUI.dialog('#winQCEntityItem').close();
     	});
     	
     	//校验规则按钮事件
     	//添加
     	$('#btnAddR').on('click', function(){
			obj.addNewRule();
     	});
     	//保存
		$('#btnSaveR').on('click', function(){
	     	obj.btnSaveR_click();
     	});
		//删除
		$('#btnDeleteR').on('click', function(){
	     	obj.btnDeleteR_click();
     	});
     }
    $('#ItemKey').searchbox({
	    searcher:function(value,name){
	    	obj.gridQCEntityItem.load({
					ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
					QueryName:"QryQCEntityItem",
					aParRef:obj.ParrefID,
					aKey:value		
					});
	    },
	    prompt:'请输入关键字/代码'
	});	
	obj.gridQCEntity_onSelect = function (rd){
		if (rd["BTID"] == obj.ParrefID) {
			obj.ParrefID=""
			obj.gridQCEntity.clearSelections();
			obj.gridQCEntityItem.loadData([]);
			
		} else {	
			obj.ParrefID=rd["BTID"]
			obj.gridQCEntityItem.load({
				    ClassName:"DHCMA.CPW.SDS.QCEntityItemSrv",
					QueryName:"QryQCEntityItem"	,
					aParRef:obj.ParrefID	
			}
			) ;
		}
	}
	obj.gridQCEntityItem_onDbselect= function (rd){
		obj.layer(rd);
	}
	obj.gridQCEntityItem_onSelect= function (rd){
		$("#btnEdit").linkbutton("enable");
		$("#btnDelete").linkbutton("enable");
	}
	//保存分类
	obj.btnSave_click = function(flg){
		var errinfo = "";
		var Code = $('#BTCode').val();
		var Desc = $('#BTDesc').val();
		var Type = $('#BTType').combobox('getValue');
		var Express=$('#BTExpress').combobox('getValue');
		var IsActive = $('#BTIsActive').checkbox('getValue');
		IsActive = (IsActive==true? 1: 0);
		var IndNo = $('#IndNo').val();
		var LinkItem = $('#BTLinkItem').combobox('getValue');
		if (typeof(LinkItem)=='undefined') LinkItem=""
		var TriggerCondition = $('#TriggerCondition').val();
		var BTExpressParam = $('#BTExpressParam').val();
		var UpType = $('#BTUpType').combobox('getValue');
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
		var inputStr=obj.ParrefID
		if (obj.ParrefID=="") {
			$.messager.alert("错误提示", "质控病种ID为空，无法保存项目内容！", 'info');
			return;
		}
		var ItemCat  = $('#BTCat').val();
		var ItemSubCat  = $('#BTSubCat').val();
		var Needed   = $('#BTIsNeeded').checkbox('getValue');
		var GetDataParam = $('#GetDataParam').combobox('getText');
		Needed = (Needed==true? 1: 0);
		inputStr = inputStr + String.fromCharCode(1) +obj.RecRowID;
		inputStr = inputStr + String.fromCharCode(1) + Code;
		inputStr = inputStr + String.fromCharCode(1) + Desc;
		inputStr = inputStr + String.fromCharCode(1) + Type;
		inputStr = inputStr + String.fromCharCode(1) + Express;
		inputStr = inputStr + String.fromCharCode(1) + IsActive;
		inputStr = inputStr + String.fromCharCode(1) + IndNo
		inputStr = inputStr + String.fromCharCode(1) + LinkItem
		inputStr = inputStr + String.fromCharCode(1) + TriggerCondition;
		inputStr = inputStr + String.fromCharCode(1) + BTExpressParam
		inputStr = inputStr + String.fromCharCode(1) + Needed
		inputStr = inputStr + String.fromCharCode(1) + ItemCat
		inputStr = inputStr + String.fromCharCode(1) + GetDataParam
		inputStr = inputStr + String.fromCharCode(1) + ItemSubCat
		inputStr = inputStr + String.fromCharCode(1) + UpType
		var flg = $m({
			ClassName:"DHCMA.CPW.SD.QCEntityItem",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:String.fromCharCode(1)
		},false);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == 0) {
				$.messager.alert("错误提示", "参数错误!" , 'info');
			} else {
				$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
			}
		}else {
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
			$HUI.dialog('#winQCEntityItem').close();
			obj.gridQCEntityItem.reload() ;//刷新当前页
		}
	}
	//删除分类 
	obj.btnDelete_click = function(){
		var rowData = obj.gridQCEntityItem.getSelected();
		var rowID=rowData["BTID"]
		if (rowID==""){
			$.messager.alert("提示", "选中数据记录,再点击删除!", 'info');
		}
		$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {				
			if (r) {				
				var flg = $m({
					ClassName:"DHCMA.CPW.SD.QCEntityItem",
					MethodName:"DeleteById",
					aId:rowID
				},false);
				if (parseInt(flg) < 0) {
					$.messager.alert("错误提示","删除数据错误!Error=" + flg, 'info');	
				} else {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					
					obj.gridQCEntityItem.reload() ;//刷新当前页	
				}
			} 
		});
	}
	//检验规则函数事件
	obj.addNewRule=function(){
		$('#RuleGrid').datagrid('appendRow',{RowID:'',QCExpressID:'',QCExpress:'',RuleExpress:'',RuleType:'error',RuleContent:''});
      	editIndex = $('#RuleGrid').datagrid('getRows').length - 1;
        $('#RuleGrid').datagrid('selectRow', editIndex).datagrid('beginEdit', editIndex);
        $("#btnSaveR").linkbutton('enable');
		$("#btnDeleteR").linkbutton('enable');	
	}
	obj.btnSaveR_click=function(){
		var Editrows=$('#RuleGrid').datagrid('getSelections')
		for (var i=0;i<Editrows.length;i++) {
			var rowIndex=$('#RuleGrid').datagrid('getRowIndex',Editrows[i])
			$('#RuleGrid').datagrid('endEdit',rowIndex)
		}
		var rows=$('#RuleGrid').datagrid('getChanges');
		var Err="";
		for (var i=0;i<rows.length;i++) {
			var rec=rows[i]
			var InputStr=obj.ItemID
			InputStr+="^"+rec.RowID
			InputStr+="^"+rec.RuleType
			InputStr+="^"+rec.QCExpressID
			InputStr+="^"+rec.RuleExpress
			InputStr+="^"+rec.RuleContent
			$m({
					ClassName:"DHCMA.CPW.SD.QCItemValidRule",
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
		obj.RuleGrid.reload()
	}
	obj.btnDeleteR_click=function(){
		var Editrows=$('#RuleGrid').datagrid('getSelections');
		for (var i=0;i<Editrows.length;i++) {
			var row=Editrows[i];
			if (row.RowID) {
				$.messager.confirm("删除", "是否删除已保存规则:"+row.RuleContent, function (r) {	
					if (r) {			
						$m({
							ClassName:"DHCMA.CPW.SD.QCItemValidRule",
							MethodName:"DeleteById",
							aId:row.RowID
							},false)
						obj.RuleGrid.reload();
					}
				})
			}
		}
		obj.RuleGrid.reload();
	}
	obj.layer= function(rd){
		if(rd){
			obj.RecRowID = rd["BTID"];
			obj.BTLinkItem=$HUI.combobox("#BTLinkItem",{
				url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryQCEntityItem&ResultSetType=Array&aParRef='+obj.ParrefID,
				valueField:'BTID',
				textField:'BTDesc',
			})
			$("#BTCode").val(rd["BTCode"])
			$("#BTDesc").val(rd["BTDesc"])
			$('#BTType').combobox('setValue', rd["BTTypeID"]);	
			$('#BTUpType').combobox('setValue', rd["BTUpTypeID"]);		
			$("#BTExpress").combobox('setValue', rd["BTExpressDr"]);
			$("#IndNo").val(rd["BTIndNo"])
			$("#BTLinkItem").combobox('setValue', rd["BTLinkedItem"]);	
			$("#TriggerCondition").val(rd["BTTriggerCondition"])
			$("#BTIsActive").checkbox('setValue',rd["BTIsActive"]=="是"?true:false)
			$("#BTExpressParam").val(rd["BTExpressParam"])
			$("#BTCat").val(rd["BTItemCat"]);
			$("#BTSubCat").val(rd["BTItemSubCat"]);
			if (rd["BTExpressCode"]=="BaseInfo") {
					$HUI.combobox("#GetDataParam",{
						url:$URL+'?ClassName=DHCMA.CPW.SDS.QCEntityItemSrv&QueryName=QryClassProperty&ResultSetType=Array&aClassName=DHCMA.Util.EPx.Episode',
						valueField:'PropertyName',
						textField:'PropertyName',	
					})
				}else{
					$('#GetDataParam').combobox('loadData', {});
				}
			$("#BTIsNeeded").checkbox('setValue',rd["BTIsNeeded"]=="是"?true:false)
			$("#GetDataParam").combobox('setValue',rd["GetDataParam"])
			
		}else{
			obj.RecRowID="";
			$("#BTCode").val('');
			$("#BTDesc").val('');
			$("#BTType").combobox('setValue','');
			$("#BTExpress").combobox('setValue','');
			$("#IndNo").val('');
			$("#BTLinkItem").combobox('setValue','');
			$("#TriggerCondition").val('');
			$("#BTIsActive").checkbox('uncheck');
			$("#TriggerCondition").val('');	
			$("#BTExpressParam").val('');
			$("#BTCat").val('');	
			$("#BTIsNeeded").val('');
			$("#GetDataParam").val('');
		}
		$HUI.dialog('#winQCEntityItem').open();
	}
	obj.ShowItemRule=function(ItemID) {
		obj.ItemID=ItemID
		obj.RuleGrid = $HUI.datagrid("#RuleGrid",{
			fit:true,
			singleSelect: false,
			autoRowHeight: false,
			striped:true,
			rownumbers:true, 
			loadMsg:'数据加载中...',
		    url:$URL,
		    nowrap:false,
		    queryParams:{
			    ClassName:"DHCMA.CPW.SDS.QCItemValidRuleSrv",
				QueryName:"QryQCItemVRule",
				aItemDr:ItemID
		    },
			columns:[[
				{field:'QCExpressID',title:'函数',width:'120',
				formatter:function(v,r){					
						return r.QCExpress
						},
				editor:{
						type:'combobox',
						panelHeight:"auto",
						options:{
							url:$URL+"?ClassName=DHCMA.CPW.SDS.QCExpressSrv&QueryName=QryQCExpress&ResultSetType=Array&aExpType=ValiRule",
							selectOnNavigation:true,
							valueField:'BTID',
							textField:'BTDesc',
							onSelect:function(rd){
							}
						}
					}
				},
				{field:'RuleExpress',title:'表达式',width:'250',
					editor:{
							type:'text'
					}
				},
				{field:'RuleType',title:'级别',align:'center',width:'100',
					formatter:function(v,r){					
						return r.RuleTypeDesc
						},
					editor:{
			                type:'combobox',
							options:{
								valueField:'id',
								textField:'text',
								selectOnNavigation:true,
								panelHeight:"auto",
								editable:false,
								data:[
									{id:'info',text:'温馨提示'},
									{id:'warning',text:'指标预警'},
									{id:'error',text:'填报错误'},
									{id:'stop',text:'终止填报'}
									
								]
							}
				}
				},
				{field:'RuleContent',title:'提示内容',width:'300',
				editor:{
							type:'text'
					}
				}
			]]
			,onClickRow:function(index,rowData){
				$("#btnSaveR").linkbutton('enable');
				$("#btnDeleteR").linkbutton('enable');
				$('#RuleGrid').datagrid('selectRow', index).datagrid('beginEdit', index);;
			}
			,onLoadSuccess:function(rowIndex,rowData){
			}
		});
		$HUI.dialog('#winQCItemRule').open();
	}
}