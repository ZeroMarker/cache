/*
Creator:LiangQiang
CreatDate:2014-11-20
Description:����ά��
*/
var url='dhcpha.clinical.action.csp' ;



var tcombclumns=[[    
					  {field:'desc',title:'����',width:150}, 
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

	   //����
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
			  rownumbers:false,//�к� 
			  pageSize:150,
			  pageList:[150,300],
			  columns:[[  
			  {field:'desc',title:'����',width:150}, 
			  {field:'code',title:'����',width:80},
			  {field:'funtions',title:'�������ʽ',width:250},
			  {field:'returnval',title:'����ֵ',width:40},
			  {field:'remark',title:'��ע',width:80},
			  {field:'active',title:'����',width:20},
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


        //����
		$("#btnAdd").click(function (e) { 

                AddFunLib(1);

         })
     
        //����
		$("#btnUpd").click(function (e) { 

                AddFunLib(2);




         })


}





///����������
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
						$.messager.alert('������ʾ','���벻��Ϊ��!',"error");
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
					$.messager.alert('������ʾ','���಻��Ϊ��!',"error");
					return;
			}

            
			if (opflag==1)
			{
				//����
				var rowid="";
				

			}
			var parentid="";
			if (opflag==2)
			{
				//����
				var row = $("#funtionsgrid").datagrid("getSelected"); 
				if (!(row))
				{	$.messager.alert('������ʾ','����ѡ��һ����¼!',"error");
					return;
				}
				var rowid=row.rowid;
				var parentid=row._parentId

						if (parentid=="")
						{
								$.messager.alert('������ʾ','��ѡ���Ӽ�¼ά��!',"error");
								return;
						}
				
			}


			var input=code+"^"+desc+"^"+active+"^"+funtions+"^"+returnvalue+"^"+remark+"^"+catdr+"^"+rowid ;
������������
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
							 $.messager.alert('������ʾ','����ʧ��!'+ret,"error");
						 }
                     }
					
		                    
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					   ret="-100" ;
					}

			    });
			

		

			



}

//ˢ��
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


