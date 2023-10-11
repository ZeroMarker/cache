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
			// ��ʾ��ݲ˵�
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
		$.messager.alert("��ʾ","��Ʒ��ֻ�������¼�����!");
		return 
		}
	
	$("#ProduceModule-dialog").dialog("open")
	InitroduceModuledialog(Type)
	}
function InitroduceModuledialog(Type){
	var node = PageLogicObj.TreenodeObj;
	$("#moduleCode").val("");    /// ��������
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
	if (Type=="S"){  //ͬ��
		if (node.masterid.indexOf("M") >=0){
			PageLogicObj.ProduceLink=node.masterid
		}else{
			PageLogicObj.ProduceModuleLink=node.masterid
			}
	}else if(Type=="C"){ //�¼�
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
			$("#moduleCode").val(value.split(String.fromCharCode(1))[0]);    /// ��������
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
		$.messager.alert("��ʾ","���벻��Ϊ��","warning");
		return false	
		}
	var moduleDesc=$("#moduleDesc").val();
	if (moduleDesc==""){
		$.messager.alert("��ʾ","��������Ϊ��","warning");
		return false	
		}
	var LinkType=""
	var checkedRadioJObj = $("input[name='LinkType']:checked");
	var LinkType=checkedRadioJObj.val()
	if (LinkType==""){
		$.messager.alert("��ʾ","���Ͳ���Ϊ��","warning");
		return false	
		}
	var LinkTypecsp=$("#LinkTypecsp").val();
	if (((LinkType=="csp")||(LinkType=="linkcsp"))&&(LinkTypecsp=="")){
		$.messager.alert("��ʾ","����csp����Ϊ��","warning");
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
		$.messager.popover({msg: '����ɹ�',type:'success'});
		$("#ProduceModule-dialog").dialog("close")
        LoadTree("")			
	}else{
		if(value=="Repeat"){
			$.messager.alert("��ʾ","�����ظ�","warning");	
		}else{
			$.messager.alert("��ʾ",value,"warning");	
		}	
	}
	}
function DelectProduce(){
	//var node = $("#treeProduce").tree('getSelected');
	var node = PageLogicObj.TreenodeObj;
	if (node.id.indexOf("M") != "-1"){
		$.messager.alert("��ʾ","��Ʒ��ģ�鲻��ɾ��","warning");	
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
            text: '����',
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
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = PageLogicObj.ProduceModuleconfigDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("��ʾ", "��ȷ��Ҫɾ����?",
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
									$.messager.popover({msg: 'ɾ���ɹ�',type:'success'});
							        LoadProduceModuleconfigGrid()	
								}
	                        }else{
								PageLogicObj.ProduceModuleconfigGridEditRow = undefined;
                				PageLogicObj.ProduceModuleconfigDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
	                        }
                        }
                    });
                } else {
                    $.messager.alert("��ʾ", "��ѡ��Ҫɾ������", "error");
                }
            }
        },{
            text: 'ȡ���༭',
            iconCls: 'icon-undo',
            handler: function() {
                //ȡ����ǰ�༭�аѵ�ǰ�༭�а�undefined�ع��ı������,ȡ��ѡ�����
                PageLogicObj.ProduceModuleconfigGridEditRow = undefined;
                PageLogicObj.ProduceModuleconfigDataGrid.datagrid("rejectChanges").datagrid("unselectAll");
            }
        },{
			text: '����',
			iconCls: 'icon-save',
			handler: function() {
				if (PageLogicObj.ProduceModuleconfigGridEditRow != undefined){
					var node = $("#treeProduce").tree('getSelected');
					var ModuleRowID=node.id
					if (ModuleRowID==""){
						$.messager.alert("��ʾ","��ѡ��һ��ģ�����ά��","warning");
						return false 	
						}
					if ((ModuleRowID.indexOf("M") != "-1")){
						$.messager.alert("��ʾ","��Ʒ�߲���ά������","warning");
						return false 
						}
					
		            var ProduceModuleconfigDataRow=PageLogicObj.ProduceModuleconfigDataGrid.datagrid("selectRow",PageLogicObj.ProduceModuleconfigGridEditRow).datagrid("getSelected"); 
		           	var RowID=ProduceModuleconfigDataRow.RowID
		           	if (RowID==undefined) RowID=""
			        var editors = PageLogicObj.ProduceModuleconfigDataGrid.datagrid('getEditors', PageLogicObj.ProduceModuleconfigGridEditRow);
			        var Code=editors[0].target.val()
			        var Desc=editors[1].target.val()
			        if (Code==""){
				        $.messager.alert("��ʾ","���벻��Ϊ��","warning");
						return false 
				        }
				    if (Desc==""){
				        $.messager.alert("��ʾ","��������Ϊ��","warning");
						return false 
				        }
					var ConfigType=editors[2].target.combobox('getValue')
					if (ConfigType==""){
				        $.messager.alert("��ʾ","���Ͳ���Ϊ��","warning");
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
						$.messager.popover({msg: '����ɹ�',type:'success'});
				        LoadProduceModuleconfigGrid()			
					}else{
						if(value=="Repeat"){
							$.messager.alert("��ʾ","�����ظ�","warning");	
						}else{
							$.messager.alert("��ʾ",value,"warning");	
						}	
					}
		        }
			}
		}];
    var ProduceModuleconfigColumns=[[   
    				{ field: 'RowID', title: 'Rowid', width: 10,hidden:true },
        			{ field: 'ConfigCode', title: '����', width: 120,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigDesc', title: '����', width: 200,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigType', title: '����', width: 80,
					   editor :{  
							type:'combobox',  
							options:{
								valueField:'ID',
								textField:'Desc',
								data:[{"ID":"text","Desc":"�ı�"},{"ID":"check","Desc":"��ѡ��"},{"ID":"Combobox","Desc":"������ѡ"},{"ID":"ComboboxM","Desc":"�������ѡ"},{"ID":"LinkBottom","Desc":"���Ӱ�ť"}]  ,
								loadFilter: function(data){
									var data=[{"ID":"text","Desc":"�ı�"},{"ID":"check","Desc":"��ѡ��"},{"ID":"Combobox","Desc":"������ѡ"},{"ID":"ComboboxM","Desc":"�������ѡ"},{"ID":"LinkBottom","Desc":"���Ӱ�ť"}]   
									return data;
								}
							  }
     					  }
					},
					{ field: 'ConfigDataType', title: '��������', width: 80,
					   editor :{  
							type:'combobox',  
							options:{
								//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.PrescriptType&QueryName=GetLimitType",
								valueField:'ID',
								textField:'Desc',
								data:[{"ID":"JSON","Desc":"JSON����"},{"ID":"M","Desc":"M���ʽ"}]  ,
								loadFilter: function(data){
									var data=[{"ID":"JSON","Desc":"JSON����"},{"ID":"M","Desc":"M���ʽ"}]  
									return data;
								}
							  }
     					  }
					},
        			{ field: 'ConfigData', title: '����', width: 300,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigDataReMark', title: '����˵��', width: 400,editor : {type : 'text',options : {}}},
        			{ field: 'ConfigLinkStr', title: '����·��', width: 400,editor : {type : 'text',options : {}}},
					
    			 ]];
	PageLogicObj.ProduceModuleconfigDataGrid=$('#ProduceModuleconfigtag').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : false,  //�Ƿ��ҳ
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
				$.messager.alert("��ʾ", "�����ڱ༭���У����ȵ������");
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
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>ҽ��վ����ʹ��˵��</li>" + 
		"<li style='font-weight:bold'>һ������ά��һ����Ʒ�ߣ�����ά������ϵ��Ʒ��Ա��</li>" + 
		"<li style='font-weight:bold'>����ɾ��ĳһ�ڵ�����������ܻ�Ӱ���Ʒ�����С�</li>" + 
		"<li style='font-weight:bold'>�������漰չʾ˵��</li>" + 
		"<li style='font-weight:bold' >1.�����չʾ�ṩ��Ĭ�ϵı��淽�������浽^DHCDocConfig��</li>" +
		"<li>   ������ʽΪ:�޹��� ����ҽ��վ��������ȡֵ ..%GetConfig(����,ҽԺ)</li>" + 
		"<li>   ������ʽΪ:���� ����ҽ��վ��������ȡֵ ..%GetConfig1(loc_����ID,����,ҽԺ)</li>" + 
		"<li>   ������ʽΪ:��ȫ�� ����ҽ��վ��������ȡֵ ..%GetConfig1(group_��ȫ��ID,����,ҽԺ)</li>" + 
		"<li>   ������ʽΪ:ҽ�� ����ҽ��վ��������ȡֵ ..%GetConfig1(arcim_ҽ����ID,����,ҽԺ)</li>" + 
		"<li style='font-weight:bold' >2.����ά�����淽��</li>" + 
		"<li>   ���淽�������:Obj ��Json����</li>"+
		"<li>   Obj=[{HospID: ҽԺ,Type:��������(none,loc,group,arcim),TypeValue:��������ID,ModuleRowID:��ҳ��ID</li>" +
		"<li>   JsonAry:[{code:����,id:Ԫ��id,dese:Ԫ������,value:Ԫ��ֵ},{...},...]}]  //��������Ԫ�ص�����</li>" +
		"<li>   ����:0Ϊ�ɹ��������Ϊ0��ʾ��������</li>" +
		"<li style='font-weight:bold'>3.����ά��չʾ������</li>" +
		"<li>   չʾ���������: Obj ��Json����</li>"+
		"<li>   Obj=[{HospID: ҽԺ,Type:��������(none,loc,group,arcim),TypeValue:��������ID,ModuleRowID:��ҳ��ID}]</li>" +
		"<li>   ���Σ�rtnObj ��Json���� (code ��id ������ѡһ���������)</li>" +
		"<li>   rtnObj=[{code:����,id:Ԫ��id,value:Ԫ��ֵ},{...},...]  //��������Ԫ�ص�����</li>"
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