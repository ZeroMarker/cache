var action="";
		
		function dataLoader(params,successcb,errorcb){
		    params.start=((params.page-1)*params.rows);
			params.limit=params.rows;
			$.ajax({
				url:'dhcwl/kpi/kpiservice.csp?action=lookupObj&className=DHCWL.MKPI.MKPIFL',
				type: "POST",
				dataType:"text",
				data:params,
				success: function(data){
					var json=eval('(' + data + ')');
					json.total=json.totalNum;
					json.rows=json.root;
					successcb(json)

				},error:function (XMLHttpRequest, textStatus, errorThrown) {
					alert("error");
				}
			});
		}
        var url;
        function create(){
            $('#dlg').dialog('open').dialog('center').dialog('setTitle','�½�');
            $('#fm').form('clear');
            action="addKpifl";
        }
		function save(){
			$.ajax({
				url:'dhcwl/kpi/kpiservice.csp?action='+action+"&"+$('#fm').serialize(),
				type: "GET",
				dataType:"text",
				success: function(data){
				    try{
						var json=eval('(' + data + ')');
						if(json.success){
							$.messager.alert('��ʾ','����ɹ���','info');
							$('#dlg').dialog('close');
							$('#dg').datagrid('reload'); 
						}
					}catch(e){
						$.messager.alert('����','��̨�������ݣ�'+data,'error');
					}
					

				},error:function (XMLHttpRequest, textStatus, errorThrown) {
					$.messager.alert('����','��������ʧ�ܣ�','error');
				}
			});
		}
        function update(){
            var row = $('#dg').datagrid('getSelected');
            if (row){
                $('#dlg').dialog('open').dialog('center').dialog('setTitle','Edit User');
                $('#fm').form('load',row);
                action="addKpifl";
				$("#MKPIFLCode").textbox('readonly',true);
            }else{
				$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
			}
        }
        function deleteRow(){
            var row = $('#dg').datagrid('getSelected');
            if (row){
                $.messager.confirm('Confirm','ȷ��Ҫɾ����',function(r){
                    if (r){
                        $.ajax({
							url:"dhcwl/kpi/kpiservice.csp?action=deleteKpifl&MKPIFLCode="+row["MKPIFLCode"],
							type: "GET",
							dataType:"text",
							success: function(data){
								try{
									var json=eval('(' + data + ')');
									if(json.success){
										$.messager.alert('��ʾ','ɾ���ɹ���','info');
										$('#dlg').dialog('close');
										$('#dg').datagrid('reload'); 
									}
								}catch(e){
									$.messager.alert('����','��̨�������ݣ�'+data,'error');
								}
								

							},error:function (XMLHttpRequest, textStatus, errorThrown) {
								$.messager.alert('����','��������ʧ�ܣ�','error');
							}
						});
                    }
                });
            }else{
				$.messager.alert('��ʾ','��ѡ��һ����¼��','info');
			}
        }
		function json2Param(json){
		  var arr=[];
		  for(var p in json){
		    arr.push(p+"="+json[p]);
		  }
		  return arr.join("&");
		}
		
$(function(){
$HUI.datagrid('#dg',{
			loader:dataLoader,
			toolbar:"#toolbar",pagination:true,
            rownumbers:true,fitColumns:true,singleSelect:true
		});	
})