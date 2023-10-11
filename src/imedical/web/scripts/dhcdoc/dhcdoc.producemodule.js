$(function(){
	Init();
	InitEvent();
});
var PageLogicObj={
	ProduceLink:"",
	ProduceModuleLink:"",
	ProduceRowID:"",
	ProduceModuleconfigDataGrid:"",
	ProduceModuleconfigGridEditRow:"",
	TreenodeObj:""
}
function InitEvent()
{
	$("#BSaveModule").click(BSaveModuledialogHandle);
	}
function Init(){
	InitTree();
	InitProduceModuleconfigTab();
	InitTip()
	}
	
function InitTree(){
	$('#treeProduce').tree({
		lines:true,autoNodeHeight:true,
		onContextMenu: function(e, node){
			
			e.preventDefault();
			PageLogicObj.TreenodeObj=node;
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onSelect:function(index,rowData){
			LoadProduceModuleconfigGrid();
			}	
	})
	LoadTree("")
	}
function producesearchItem(desc, name){
	LoadTree(desc)
	}
function LoadTree(desc){
	$.cm({
        ClassName: 'DHCDoc.DHCDocConfig.DHCDocProduceModule',
        MethodName: 'FindMasterProduceTree',
        desc:desc
    }, function (data) {
        $('#treeProduce').tree({
            data: data
        });
    });
	}
function CreateProduce(Type){
	var node = PageLogicObj.TreenodeObj;
	if ((node.id.indexOf("M") != "-1")&&((Type=="U")||(Type=="S"))){
		$.messager.alert("提示","产品线只能增加下级分类!");
		return 
		}
	
	$("#ProduceModule-dialog").dialog("open")
	InitroduceModuledialog(Type)
	}
function InitroduceModuledialog(Type){
	var node = PageLogicObj.TreenodeObj;
	$("#moduleCode").val("");    /// 分类名称
	$("#moduleDesc").val(""); 
	$("#LinkTypecsp").val(""); 
	$("#moduleRemark").val(""); 
	$("#SaveMethod").val(""); 
	$("#ShowMethod").val("");
	PageLogicObj.ProduceLink=""
	PageLogicObj.ProduceModuleLink=""
	PageLogicObj.ProduceRowID=""
	$HUI.radio("input[name='csplocation']").setValue(false)
	$HUI.radio("input[name='LinkType']").setValue(false)
	$HUI.switchbox('#UseDefault').setValue(false)
	if (Type=="S"){  //同级
		if (node.masterid.indexOf("M") >=0){
			PageLogicObj.ProduceLink=node.masterid
		}else{
			PageLogicObj.ProduceModuleLink=node.masterid
			}
	}else if(Type=="C"){ //下级
		if (node.id.indexOf("M") >=0){
			PageLogicObj.ProduceLink=node.id
		}else{
			PageLogicObj.ProduceModuleLink=node.id	
			}	
	}else if(Type=="U"){
		PageLogicObj.ProduceRowID=node.id
		var value=$.m({
			ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
			MethodName:"ShowProduceModule",
	   		RowID :PageLogicObj.ProduceRowID
		},false);	
		if (value!=""){
			$("#moduleCode").val(value.split(String.fromCharCode(1))[0]);    /// 分类名称
			$("#moduleDesc").val(value.split(String.fromCharCode(1))[1]);
			$HUI.radio("input[value='"+value.split(String.fromCharCode(1))[2]+"']").setValue(true)
			$HUI.radio("input[value='"+value.split(String.fromCharCode(1))[3]+"']").setValue(true)
			$("#LinkTypecsp").val(value.split(String.fromCharCode(1))[4]); 
			$("#moduleRemark").val(value.split(String.fromCharCode(1))[5]);
			PageLogicObj.ProduceLink=value.split(String.fromCharCode(1))[6]
			PageLogicObj.ProduceModuleLink=value.split(String.fromCharCode(1))[7]	
			$("#SaveMethod").val(value.split(String.fromCharCode(1))[8]); 
			$("#ShowMethod").val(value.split(String.fromCharCode(1))[9]);
			if ((value.split(String.fromCharCode(1))[9]=="##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).ShowOneProduceModuleValue(Obj)")&&(value.split(String.fromCharCode(1))[8]=="##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).SaveProduceModuleValue(Obj)")){
				$HUI.switchbox('#UseDefault').setValue(true)
				$("#SaveMethod").attr("disabled",true);
				$("#ShowMethod").attr("disabled",true);
				}else{
				$HUI.switchbox('#UseDefault').setValue(false)
				$("#SaveMethod").attr("disabled",false);
				$("#ShowMethod").attr("disabled",false);	
				}
			}
		}
}
function BSaveModuledialogHandle(){
	var moduleCode=$("#moduleCode").val();
	if (moduleCode==""){
		$.messager.alert("提示","代码不能为空","warning");
		return false	
		}
	var moduleDesc=$("#moduleDesc").val();
	if (moduleDesc==""){
		$.messager.alert("提示","描述不能为空","warning");
		return false	
		}
	var LinkType=""
	var checkedRadioJObj = $("input[name='LinkType']:checked");
	var LinkType=checkedRadioJObj.val()
	if (LinkType==""){
		$.messager.alert("提示","类型不能为空","warning");
		return false	
		}
	var LinkTypecsp=$("#LinkTypecsp").val();
	if (((LinkType=="csp")||(LinkType=="linkcsp"))&&(LinkTypecsp=="")){
		$.messager.alert("提示","关联csp不能为空","warning");
		return false
		}
	var moduleRemark=$("#moduleRemark").val(); 
	var csplocationRadioObj = $("input[name='csplocation']:checked");
	var Linkcsplocation=csplocationRadioObj.val()
	var SaveMethod=$("#SaveMethod").val(); 
	var ShowMethod=$("#ShowMethod").val(); 
	 var value=$.m({
		ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
		MethodName:"InsertProduceModule",
	   	RowID :PageLogicObj.ProduceRowID, Code:moduleCode, Desc:moduleDesc, LinkType:LinkType, Linkcsp:LinkTypecsp, 
	   	ProduceLink:PageLogicObj.ProduceLink,ProduceModuleLink:PageLogicObj.ProduceModuleLink, Remark:moduleRemark,
	   	Linkcsplocation:Linkcsplocation,SaveMethod:SaveMethod,ShowMethod:ShowMethod
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功',type:'success'});
		$("#ProduceModule-dialog").dialog("close")
        LoadTree("")			
	}else{
		if(value=="Repeat"){
			$.messager.alert("提示","数据重复","warning");	
		}else{
			$.messager.alert("提示",value,"warning");	
		}	
	}
	}
function DelectProduce(){
	//var node = $("#treeProduce").tree('getSelected');
	var node = PageLogicObj.TreenodeObj;
	if (node.id.indexOf("M") != "-1"){
		$.messager.alert("提示","产品线模块不可删除","warning");	
		return;
		}
	var value=$.m({
		ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
		MethodName:"delectProduceModule",
	   	RowID :node.id
	},false);
	LoadTree("")
}


function InitProduceModuleconfigTab(){
	 var ProduceModuleconfigToolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	PageLogicObj.ProduceModuleconfigGridEditRow = undefined;
                PageLogicObj.ProduceModuleconfigDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
                
                PageLogicObj.ProduceModuleconfigDataGrid.datagrid("insertRow", {
                    index: 0,
                    row: {}
                });
                PageLogicObj.ProduceModuleconfigDataGrid.datagrid("beginEdit", 0);
                PageLogicObj.ProduceModuleconfigGridEditRow = 0;
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.ProduceModuleconfigDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
	                        var rows = PageLogicObj.ProduceModuleconfigDataGrid.datagrid("getSelections");
	                        Rowid=rows[0].RowID
	                        if (Rowid){
		                        var value=$.m({
									ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
									MethodName:"DelectModuleConfig",
								   	RowID:Rowid
								},false);
								if(value=="0"){
									$.messager.popover({msg: '删除成功',type:'success'});
							        LoadProduceModuleconfigGrid()	
								}
	                        }else{
								PageLogicObj.ProduceModuleconfigGridEditRow = undefined;
                				PageLogicObj.ProduceModuleconfigDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-undo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                PageLogicObj.ProduceModuleconfigGridEditRow = undefined;
                PageLogicObj.ProduceModuleconfigDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				if (PageLogicObj.ProduceModuleconfigGridEditRow != undefined){
					var node = $("#treeProduce").tree('getSelected');
					var ModuleRowID=node.id
					if (ModuleRowID==""){
						$.messager.alert("提示","请选择一个模块进行维护","warning");
						return false 	
						}
					if ((ModuleRowID.indexOf("M") != "-1")){
						$.messager.alert("提示","产品线不能维护数据","warning");
						return false 
						}
					
		            var ProduceModuleconfigDataRow=PageLogicObj.ProduceModuleconfigDataGrid.datagrid("selectRow",PageLogicObj.ProduceModuleconfigGridEditRow).datagrid("getSelected"); 
		           	var RowID=ProduceModuleconfigDataRow.RowID
		           	if (RowID==undefined) RowID=""
			        var editors = PageLogicObj.ProduceModuleconfigDataGrid.datagrid('getEditors', PageLogicObj.ProduceModuleconfigGridEditRow);
			        var Code=editors[0].target.val()
			        var Desc=editors[1].target.val()
			        if (Code==""){
				        $.messager.alert("提示","代码不能为空","warning");
						return false 
				        }
				    if (Desc==""){
				        $.messager.alert("提示","描述不能为空","warning");
						return false 
				        }
					var ConfigType=editors[2].target.combobox('getValue')
					if (ConfigType==""){
				        $.messager.alert("提示","类型不能为空","warning");
						return false 
				        }
					var ConfigDataType=editors[3].target.combobox('getValue')
					var ConfigData=editors[4].target.val()
			        var ConfigDataReMark=editors[5].target.val()
			        var ConfigLinkStr=editors[6].target.val()
			        var value=$.m({
						ClassName:"DHCDoc.DHCDocConfig.DHCDocProduceModule",
						MethodName:"InsertModuleConfig",
					   	ModuleRowID:ModuleRowID, RowID:RowID, Code:Code, Desc:Desc, ConfigType:ConfigType, 
					   	ConfigDataType:ConfigDataType, ConfigData:ConfigData, ConfigDataReMark:ConfigDataReMark,
					   	ConfigLinkStr:ConfigLinkStr
					},false);
					if(value=="0"){
						$.messager.popover({msg: '保存成功',type:'success'});
				        LoadProduceModuleconfigGrid()			
					}else{
						if(value=="Repeat"){
							$.messager.alert("提示","数据重复","warning");	
						}else{
							$.messager.alert("提示",value,"warning");	
						}	
					}
		        }
			}
		}];
    var ProduceModuleconfigColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
        			{ field: 'ConfigCode', title: '代码', width: 120,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigDesc', title: '名称', width: 200,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigType', title: '类型', width: 80,
					   editor :{  
							type:'combobox',  
							options:{
								valueField:'ID',
								textField:'Desc',
								data:[{"ID":"text","Desc":"文本"},{"ID":"check","Desc":"勾选框"},{"ID":"Combobox","Desc":"下拉框单选"},{"ID":"ComboboxM","Desc":"下拉框多选"},{"ID":"LinkBottom","Desc":"链接按钮"}]  ,
								loadFilter: function(data){
									var data=[{"ID":"text","Desc":"文本"},{"ID":"check","Desc":"勾选框"},{"ID":"Combobox","Desc":"下拉框单选"},{"ID":"ComboboxM","Desc":"下拉框多选"},{"ID":"LinkBottom","Desc":"链接按钮"}]   
									return data;
								}
							  }
     					  }
					},
					{ field: 'ConfigDataType', title: '数据类型', width: 80,
					   editor :{  
							type:'combobox',  
							options:{
								//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetLimitType",
								valueField:'ID',
								textField:'Desc',
								data:[{"ID":"JSON","Desc":"JSON数据"},{"ID":"M","Desc":"M表达式"}]  ,
								loadFilter: function(data){
									var data=[{"ID":"JSON","Desc":"JSON数据"},{"ID":"M","Desc":"M表达式"}]  
									return data;
								}
							  }
     					  }
					},
        			{ field: 'ConfigData', title: '数据', width: 300,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigDataReMark', title: '数据说明', width: 400,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigLinkStr', title: '链接路径', width: 400,editor : {type : 'text',options : {}}},
					
    			 ]];
	PageLogicObj.ProduceModuleconfigDataGrid=$('#ProduceModuleconfigtag').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"RowID",
		//pageList : [15,50,100,200],
		columns :ProduceModuleconfigColumns,
		toolbar :ProduceModuleconfigToolBar,
		onClickRow:function(rowIndex, rowData){
			PageLogicObj.ProduceModuleconfigDataGrid.datagrid('selectRow',rowIndex);
			SelectedRow=rowIndex
			var selected=PageLogicObj.ProduceModuleconfigDataGrid.datagrid('getRows'); 
		},
		onDblClickRow:function(rowIndex, rowData){
			if (PageLogicObj.ProduceModuleconfigGridEditRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存");
		        return false;
			}
			PageLogicObj.ProduceModuleconfigDataGrid.datagrid("beginEdit", rowIndex);
			PageLogicObj.ProduceModuleconfigGridEditRow=rowIndex;
		}
	});
	//LoadProduceModuleconfigGrid()
	
}
function LoadProduceModuleconfigGrid(){
	var node = $("#treeProduce").tree('getSelected');
	$.q({
	    ClassName : "DHCDoc.DHCDocConfig.DHCDocProduceModule",
	    QueryName : "FindModuleConfig",
	    ModuleRowID :node.id,
	    Pagerows:PageLogicObj.ProduceModuleconfigDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.ProduceModuleconfigDataGrid.datagrid('loadData',GridData);
		PageLogicObj.ProduceModuleconfigGridEditRow=undefined
		PageLogicObj.ProduceModuleconfigDataGrid.datagrid("clearSelections")
	})
}
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>医生站设置使用说明</li>" + 
		"<li style='font-weight:bold'>一、不能维护一级产品线，如需维护请联系产品人员。</li>" + 
		"<li style='font-weight:bold'>二、删除某一节点需谨慎，可能会影响产品的运行。</li>" + 
		"<li style='font-weight:bold'>三、保存及展示说明</li>" + 
		"<li style='font-weight:bold' >1.保存和展示提供了默认的保存方法，保存到^DHCDocConfig里</li>" +
		"<li>   关联方式为:无关联 可用医生站公共方法取值 ..%GetConfig(代码,医院)</li>" + 
		"<li>   关联方式为:科室 可用医生站公共方法取值 ..%GetConfig1(loc_科室ID,代码,医院)</li>" + 
		"<li>   关联方式为:安全组 可用医生站公共方法取值 ..%GetConfig1(group_安全组ID,代码,医院)</li>" + 
		"<li>   关联方式为:医嘱 可用医生站公共方法取值 ..%GetConfig1(arcim_医嘱项ID,代码,医院)</li>" + 
		"<li style='font-weight:bold' >2.单独维护保存方法</li>" + 
		"<li>   保存方法的入参:Obj 的Json对象</li>"+
		"<li>   Obj=[{HospID: 医院,Type:关联类型(none,loc,group,arcim),TypeValue:关联数据ID,ModuleRowID:此页面ID</li>" +
		"<li>   JsonAry:[{code:代码,id:元素id,dese:元素描述,value:元素值},{...},...]}]  //界面所有元素的数据</li>" +
		"<li>   出参:0为成功，如果不为0提示返回内容</li>" +
		"<li style='font-weight:bold'>3.单独维护展示方法。</li>" +
		"<li>   展示方法的入参: Obj 的Json对象</li>"+
		"<li>   Obj=[{HospID: 医院,Type:关联类型(none,loc,group,arcim),TypeValue:关联数据ID,ModuleRowID:此页面ID}]</li>" +
		"<li>   出参：rtnObj 的Json对象 (code 和id 可以任选一个输出即可)</li>" +
		"<li>   rtnObj=[{code:代码,id:元素id,value:元素值},{...},...]  //界面所有元素的数据</li>"
	$("#tip").popover({
		width:750,
		height:600,
		trigger:'hover',
		content:_content
	});
}
function ChangeUseDefault(event,obj){
	if (obj.value==true){
		$("#SaveMethod").val("##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).SaveProduceModuleValue(Obj)");
		$("#ShowMethod").val("##class(DHCDoc.DHCDocConfig.DHCDocProduceModule).ShowOneProduceModuleValue(Obj)");
		$("#SaveMethod").attr("disabled",true);
		$("#ShowMethod").attr("disabled",true);
		}else{
		$("#SaveMethod").val("");
		$("#ShowMethod").val("");
		$("#SaveMethod").attr("disabled",false);
		$("#ShowMethod").attr("disabled",false);	
		}
	}