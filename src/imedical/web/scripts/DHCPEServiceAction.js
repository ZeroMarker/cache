//DHCPEServiceAction.js

var init = function(){
	
	$("#queryBtn").click(function(arg){
		search();
	});
	
	$("#clear").click(function(arg){
		$("#s_actionCode").val("");
		$("#s_aticonDesc").val("");
		$("#s_class").val("");
		$("#s_method").val("");
	});
	
	$("#s_actionCode").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			search();
		}
	});
	
	$("#s_aticonDesc").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			search();
		}
	});
	
	$("#s_class").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			search();
		}
	});
	
	$("#s_method").keydown(function(e){
 		 var Key=websys_getKey(e);
		if ((13==Key)) {
			search();
		}
	});
	
    var search=function(){
	    var s_actionCode=$("#s_actionCode").val();
		var s_aticonDesc=$("#s_aticonDesc").val();
		var s_class=$("#s_class").val();
		var s_method=$("#s_method").val();
        actionListObj.load(
        {
	        ClassName:"web.DHCPE.DHCPEServiceAction",
			QueryName:"DataListQuery",
			txtActionCode:s_actionCode,
			txtActionName:s_aticonDesc,
			txtClassName:s_class,
			txtMethodName:s_method
		});
    }
	var saveHandler = function(id,code,name,className,methodName){
		$("#in_ID").val(id);
		$("#in_code").val(code);
		$("#in_name").val(name);
		$("#in_class").val(className);
		$("#in_method").val(methodName);
		$("#actionDlg").show();
		var actionDlgObj = $HUI.dialog("#actionDlg",{
			iconCls:'icon-save',
			resizable:true,
			modal:true,
			buttons:[{
				text:'����',
				handler:function(){
					var ParmList=$("#in_code").val()+"^"+$("#in_name").val()+"^"+$("#in_class").val()+"^"+$("#in_method").val();
					var data=$.cm({ClassName:"web.DHCPE.DHCPEServiceAction",MethodName:"SaveRetJson",
							"ID":$("#in_ID").val(),
							"ParmList":ParmList
						},function(data){
							if("0"==data.ResultCode){
								actionDlgObj.close();
								actionListObj.load();
							}else{
								$.messager.alert("����",data.ResultDesc);
							}						
						});
				}
			},{
				text:'�ر�',
				handler:function(){
					actionDlgObj.close();
				}
			}]
		});	
	}
	var importHandler = function(){
		$("#importDlg").show();
		var importDlgObj = $HUI.dialog("#importDlg",{
			iconCls:'icon-add-diag',
			resizable:false,
			modal:true,
			buttons:[{
				text:'����',
				handler:function(){
					var Template=$("#file").val();
					var checkedRadioObj = $("input[name='importWay']:checked");
            		//$.messager.alert("��ʾ","value="+checkedRadioObj.val()+" , label="+checkedRadioObj.attr("label"));
            		var Type="";
            		if(checkedRadioObj!=null){
	            		Type=checkedRadioObj.val();
            		}
            		if(Template==""){
	            		$.messager.alert("����","��ѡ����ģ��");
	            		return false;
            		}
            		var extend = Template.substring(Template.lastIndexOf(".")+1);
					if(!(extend=="xls"||extend=="xlsx")){
						$.messager.alert("����","��ѡ��xls�ļ�");
						return false;
					}
					importDlgObj.close();
					$.messager.progress({ 
       					 msg: '�����У����Ժ򡭡�', 
       					 text: '' 
    				});
					Import(Template,Type);
					$.messager.progress('close');
					actionListObj.load();
				}
			},{
				text:'�ر�',
				handler:function(){
					importDlgObj.close();
				}
			}]
		});
	}
var exportHandler = function(){
	/*var rtn = $.cm({
		ClassName:"web.DHCPE.DHCPEServiceAction",
		QueryName:"DataListQuery"
	},true);*/
	var rtn=tkMakeServerCall("websys.Query","ToExcel","DHCPEServiceAction","web.DHCPE.DHCPEServiceAction","DataListQuery");

	location.href = rtn;
}

	$HUI.radio("[name='importWay']",{
            onChecked:function(e,value){
	           var srcId=e.target.id;
	           if(srcId!=""){
		           var labelId=srcId.split("_")[1];
		           for(var i=1;i<=3;i++){
			        	if(labelId==i){
				       		$("#l_"+i).css("color","deeppink");  
		        			$("#l_"+i).css("fontWeight","bold");  
		        			$("#l_"+i).css("fontSize","16px"); 
			        	}else{
				        	$("#l_"+i).css("color","");  
		        			$("#l_"+i).css("fontWeight","");  
		        			$("#l_"+i).css("fontSize",""); 
			        	}
		           }		        	
	           } 
	           // e.target.parentElement.parentElement.children[6].style.color="red";
	           // e.target.parentElement.parentElement.children[6].style.fontWeight="bold";
      
            }
      });
	$HUI.radio("#r_1").setValue(true);
	
	var actionListObj = $HUI.datagrid("#actionList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.DHCPEServiceAction",
			QueryName:"DataListQuery",
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1){
				var p = actionListObj.getPanel();
				p.find("#editIcon").linkbutton("enable",false);
				p.find("#delIcon").linkbutton("enable",false);
			}
		},
		onDblClickRow:function(index,row){
				saveHandler(row.ID,row.ActionCode,row.ActionName,row.ClassName,row.MethodName);													
			},	
		columns:[[
			{field:'ActionCode',width:'150',title:'ҵ�����',sortable:'true'},
			{field:'ActionName',width:'350',title:'ҵ������'},
			{field:'ClassName',width:'350',title:'ҵ����'},
			{field:'MethodName',width:'350',title:'������'},
			{field:'ID',hidden:true,title:'ID'}
		]],
		pagination:true,
		pageSize:20,
		fit:true,
		rownumbers:true,
		toolbar:[
		'-',{
			iconCls:'icon-add',
			text:'����',
			handler:function(){
				saveHandler("","","","","");
			}
		},{
			iconCls:'icon-save',
			text:'�༭',
			disabled:true,
			id:'editIcon',
			handler:function(){
				var rows = actionListObj.getSelections();
				if (rows.length>1){
					$.messager.alert("��ʾ","�༭ģʽ���ɶ�ѡ");
				}else if (rows.length==1){
					saveHandler(rows[0].ID,rows[0].ActionCode,rows[0].ActionName,rows[0].ClassName,rows[0].MethodName);													
				}else{
					$.messager.alert("��ʾ","��ѡ��Ҫ�༭������");
				}
			}
		},{
			iconCls:'icon-close',
			text:'ɾ��',
			disabled:true,
			id:'delIcon',
			handler:function(){
				var rows = actionListObj.getSelections();
				if (rows.length>0){
					$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){
						if(r){
							for(var i=0; i<rows.length; i++){
								$.cm({ClassName:'web.DHCPE.DHCPEServiceAction',MethodName:'Delete','ID':rows[i].ID},function(data){
									if(data!="0"){
										$.messager.alert("����",data);
										return false;
									}
								});
							}
							actionListObj.load();							
						}
					});
				}else{
					$.messager.alert("��ʾ","��ѡ��Ҫɾ��������");
				}
			}
		},
		{
			iconCls:'icon-add-diag',
			text:'����',
			id:'importIcon',
			handler:importHandler
		},
		{
			iconCls:'icon-end-adm',
			text:'����',
			id:'exportIcon',
			handler:exportHandler
		}]
	})
	
};
$(init);
