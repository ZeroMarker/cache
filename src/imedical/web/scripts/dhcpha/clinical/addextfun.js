/*
Creator:LiangQiang
CreatDate:2014-11-20
Description:函数维护
*/
var url='dhcpha.clinical.action.csp' ;



var tcombclumns=[[    
					  {field:'desc',title:'分类',width:150}, 
					  {field:'rowid',title:'rowid',width:50,hidden:true} 
				  ]];


var cbg= {
	url: url+'?action=QueryFunCatList&page=1&rows=150&input=Y',
	pw:350,
	columns: tcombclumns, 
	pagesize:150,  
	combo: '#catcombo', 
	idfield:'rowid',
	textfield:'desc',
    valuefield:'rowid',
	multiple:false


}

var catgrid;

function BodyLoadHandler()
{

	   //分类
	   catgrid=new ComboGrid(cbg);
       catgrid.init(); 

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
			  {field:'desc',title:'描述',width:150}, 
			  {field:'code',title:'代码',width:80},
			  {field:'funtions',title:'函数表达式',width:250},
			  {field:'returnval',title:'返回值',width:40},
			  {field:'remark',title:'备注',width:80},
			  {field:'active',title:'启用',width:20},
			  {field:'catdr',title:'catdr',hidden:true},
			  {field:'rowid',title:'rowid',hidden:true},
			  {field:'_parentId',title:'parentId',hidden:true}
			  ]],
			  url:url,
			  queryParams: {
					action:'QueryFunLibList'
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


}





///新增函数库
function AddFunLib(opflag)
{            
	        	
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


			var catdr="";
			var catcombo=$("#catcombo").combogrid("grid");
			var rows  = catcombo.datagrid('getSelections');
			for(var i=0; i<rows.length; i++){
					var row = rows[i];
					catdr=row.rowid ;


			}


			if (catdr=="")
			{
					$.messager.alert('错误提示','分类不能为空!',"error");
					return;
			}

            
			if (opflag==1)
			{
				//增加
				var rowid="";
				

			}
			var parentid="";
			if (opflag==2)
			{
				//更新
				var row = $("#funtionsgrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('错误提示','请先选择一条记录!',"error");
					return;
				}
				var rowid=row.rowid;
				var parentid=row._parentId

						if (parentid=="")
						{
								$.messager.alert('错误提示','请选择子记录维护!',"error");
								return;
						}
				
			}


			var input=code+"^"+desc+"^"+active+"^"+funtions+"^"+returnvalue+"^"+remark+"^"+catdr+"^"+rowid ;
　　　　　　
			var data = jQuery.param({ "action":"AddPhFuns","input":input});

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
						 }else{
							 $.messager.alert('错误提示','更新失败!'+ret,"error");
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
				action: 'QueryFunLibList'
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


	$("#catcombo").combogrid("clear"); 
	$('#catcombo').combogrid('grid').datagrid('selectRecord',rowData.catdr);


}


