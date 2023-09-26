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
            $('#dlg').dialog('open').dialog('center').dialog('setTitle','新建');
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
							$.messager.alert('提示','保存成功！','info');
							$('#dlg').dialog('close');
							$('#dg').datagrid('reload'); 
						}
					}catch(e){
						$.messager.alert('错误','后台返回数据：'+data,'error');
					}
					

				},error:function (XMLHttpRequest, textStatus, errorThrown) {
					$.messager.alert('错误','网络请求失败！','error');
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
				$.messager.alert('提示','请选择一条记录！','info');
			}
        }
        function deleteRow(){
            var row = $('#dg').datagrid('getSelected');
            if (row){
                $.messager.confirm('Confirm','确定要删除？',function(r){
                    if (r){
                        $.ajax({
							url:"dhcwl/kpi/kpiservice.csp?action=deleteKpifl&MKPIFLCode="+row["MKPIFLCode"],
							type: "GET",
							dataType:"text",
							success: function(data){
								try{
									var json=eval('(' + data + ')');
									if(json.success){
										$.messager.alert('提示','删除成功！','info');
										$('#dlg').dialog('close');
										$('#dg').datagrid('reload'); 
									}
								}catch(e){
									$.messager.alert('错误','后台返回数据：'+data,'error');
								}
								

							},error:function (XMLHttpRequest, textStatus, errorThrown) {
								$.messager.alert('错误','网络请求失败！','error');
							}
						});
                    }
                });
            }else{
				$.messager.alert('提示','请选择一条记录！','info');
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