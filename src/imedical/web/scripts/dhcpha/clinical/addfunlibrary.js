/*
Creator:LiangQiang
CreatDate:2014-06-20
Description:用药监控查询
*/
var url='dhcpha.clinical.action.csp' ;


function BodyLoadHandler()
{

	

	$('#funtionsgrid').treegrid({  
			  bordr:false,
			  fit:true,
			  fitColumns:true,
			  singleSelect:true,
			  idField:'rowid', 
			  treeField:'desc',
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:false,//行号 
			  pageSize:150,
			  pageList:[150,300],
			  columns:[[  
			  {field:'desc',title:'描述',width:100}, 
			  {field:'code',title:'代码',width:80},
			  {field:'funtions',title:'函数表达式',width:200},
			  {field:'returnval',title:'返回值',width:80},
			  {field:'remark',title:'备注',width:80},
			  {field:'active',title:'启用',width:60},
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryFuntionLib'
			  },
			  onClickRow:function(rowData){ 
		      
			       ShowText(rowData);

 
			  }



		  });


        //新增
		$("#btnAdd").click(function (e) { 

                AddFunLib(1);

         })
     
        //更新
		$("#btnUpd").click(function (e) { 

                AddFunLib(2);




         })
       //	清屏
       $("#btnClear").click(function (e) { 

                ClearFunLib();

         })

}





///新增函数库
function AddFunLib(opflag)
{
                var row=$("#funtionsgrid").datagrid("getSelected");
	        if (opflag=="1")
			{
				//增加
				var rowid="";
			}
			if (opflag=="2")
			{
				//更新
				
				if (!row)
					{
								$.messager.alert('错误提示','请先选择需要更新的函数项!',"error");
								return;
					}
				var rowid=row.rowid;
			    
			}	            
	        	
			var code=$.trim($("#code").val());
			var desc=$.trim($("#desc").val());
  
	
			var active="N";
			if ($('#chkactive').attr('checked')) 
			{
				var active="Y" ;
			 }
            var funtions=$.trim($("#funtions").val());
			var returnvalue=$.trim($("#returnvalue").val());
			var remark=$.trim($("#remark").val());
			
            
			if (code=="")
			{
						$.messager.alert('错误提示','代码不能为空!',"error");
						return;
			}
               /*       if (funtions=="")
			{
						$.messager.alert('错误提示','函数不能为空!',"error");
						return;
			}
		*/    //qunianpeng 2016/10/10

			if (!(row))
				{	$.messager.alert('错误提示','请先选择一条记录!',"error");
					return;
			}

			var parentid=row.rowid;



			var input=code+"^"+desc+"^"+active+"^"+funtions+"^"+returnvalue+"^"+remark+"^"+parentid+"^"+rowid ;
　　　　　　
			var data = jQuery.param({ "action":"AddFunLib","input":input});

			var request = $.ajax({
				url: url,
				type: "POST",
				async: true,
				data: data,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
                     if (r)
                     {
						 ret=r.retvalue; 
                         
						 if (ret=="0")
						 {
							 ReLoad();
                                                 $.messager.alert('提示','保存成功！')
						 }else{
							$.messager.alert('错误提示','该函数库已存在,保存失败！',"error");
						 }
                     }
					
		                    
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					   ret="-100" ;
					}

			    });
			

		

			



}

//刷新
function ReLoad()
{
	
	$('#funtionsgrid').treegrid('load',  {  
				action: 'QueryFuntionLib'
	});

	
}


function ShowText(rowData)
{
	$("#code").val(rowData.code);
	$("#desc").val(rowData.desc);
    $("#funtions").val(rowData.funtions);
	$("#returnvalue").val(rowData.returnval);
	$("#remark").val(rowData.remark);
	var active=rowData.active ;
	if (active=="Y")
	{
		$('#chkactive').attr("checked",true);
	}else{
		
        $('#chkactive').attr("checked",false);
	}


}
 function ClearFunLib(){
	$("#code").val("");
        $("#desc").val("");
	$("#chkactive").attr("checked",false)//未选中
        $("#funtions").val("");
        $("#returnvalue").val("");
	$("#remark").val("");	 
 }

