
//����	DHCPESpecialItemContral.hisui.js
//����	���������ĿȨ�޹���
//����	2019.05.17
//������  xy

$(function(){
		
	InitCombobox();
	
	InitSpecItemContDataGrid();
    
    InitSpecItemContDetailDataGrid(); 
    
    //����
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
         
    //ɾ��
	$("#BDelete").click(function() {	
		Delete_Click();		
        });
        
     //����
	$("#BSave").click(function() {	
		BSave_Click();		
        });
    
    })

//����
function BAdd_click()
{
	
	var UserID=$("#UserName").combogrid('getValue')
	 if (($("#UserName").combogrid('getValue')==undefined)||($("#UserName").combogrid('getValue')=="")){var UserID="";}
   
	if (UserID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsUser",UserID);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ���û�","info");
				return false;
				}
		}else{
			var valbox = $HUI.combogrid("#UserName", {
				required: true,
	    	});
			$.messager.alert("��ʾ","�û�����Ϊ��","info");
			return false;
		}
	
	 
	var ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","AddSpecialItemContralUser",UserID);
	if(ret="0"){
			$.messager.popover({msg: '�����ɹ�',type:'success',timeout: 1000});
			
			$("#SpecialItemContralTab").datagrid('load',{
				ClassName:"web.DHCPE.SpecialItemContral",
				QueryName:"SearchSpecialItemContral",
			});
			
		}

	
}

//ɾ��
function Delete_Click()
 {
	var UserID=$("#ID").val()
	
	if (""==UserID) {
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼","info");	
		return false;
	 }

	var ret="";

	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.SpecialItemContral", MethodName:"DelSpecialItemContralUser",UserID:UserID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#ID").val("");	
					$("#SpecialItemContralTab").datagrid('load',{
						ClassName:"web.DHCPE.SpecialItemContral",
						QueryName:"SearchSpecialItemContral",
					});
				$('#SpecialItemContralDetailTab').datagrid('load', {
					ClassName: 'web.DHCPE.SpecialItemContral',
					QueryName: 'SearcgSIContralDetail',
					UserID: UserID,
		
				});
     
				}
			});	
		}
	});
	
	
 }

 
 //����
 function BSave_Click()
 {
	  var str="";
	 var selectrow = $("#SpecialItemContralDetailTab").datagrid("getChecked");//��ȡ�������飬��������
	for(var i=0;i<selectrow.length;i++){
		//alert(selectrow[i].TItemID)
		if(str==""){str=selectrow[i].TItemID;}
		else{str=str+"^"+selectrow[i].TItemID;}
			
	}
	 
	var UserID=$('#UserID').val();
	if (UserID==""){
		$.messager.alert("��ʾ","����Ա����Ϊ��","info");	
		return false;
	}
	
	var Ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","SaveNew",UserID,str);
	if (Ret=="0"){
		$.messager.alert("��ʾ","����ɹ�","success");
		$("#SpecialItemContralDetailTab").datagrid('load',{
			ClassName:"web.DHCPE.SpecialItemContral",
			QueryName:"SearcgSIContralDetail",
			UserID:UserID,
	        
			});

	}
	else {$.messager.alert("��ʾ","����ʧ��","error");}
	
 }
 
function InitCombobox()
{
		//����Ա
	   var OPNameObj = $HUI.combogrid("#UserName",{
		panelWidth:470,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.Report.DoctorWorkStatistic&QueryName=SearchUSERSXT",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'DocDr',
		textField:'DocName',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'DocDr',title:'ID',width:50},
			{field:'DocName',title:'����',width:200},
			{field:'Initials',title:'����',width:190}	
				
		]],
		onLoadSuccess:function(){
			//$("#UserName").combogrid('setValue',""); 
		},

		});	 
} 

function InitSpecItemContDataGrid()
{
	$HUI.datagrid("#SpecialItemContralTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.SpecialItemContral",
			QueryName:"SearchSpecialItemContral",
		},
		columns:[[
	
		    {field:'UserID',title:'UserID',hidden: true},
			{field:'UserCode',width:'200',title:'����'},
			{field:'UserName',width:'290',title:'ҽ��'}
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
			$('#ID').val(rowData.UserID); 
			$('#SpecialItemContralDetailTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadSpecItemContDetail(rowData);		
				
			
		}
		
			
	})

}


function loadSpecItemContDetail(row) {
	
	$('#SpecialItemContralDetailTab').datagrid('load', {
		ClassName: 'web.DHCPE.SpecialItemContral',
		QueryName: 'SearcgSIContralDetail',
		UserID: row.UserID,
		
	});
     $('#UserID').val(row.UserID);
	
}


function  InitSpecItemContDetailDataGrid()
{
		$HUI.datagrid("#SpecialItemContralDetailTab",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.SpecialItemContral",
			QueryName:"SearcgSIContralDetail",
			UserID:$("#UserID").val(),
		},
		frozenColumns:[[
			{title: 'ѡ��',field: 'Select',width: 60,checkbox:true},
		]],
		columns:[[
	
		    {field:'TItemID',title:'ItemID',hidden: true},
			{field:'TItemName',width:'600',title:'��Ŀ����'},
			
		
		]],
		onLoadSuccess: function (rowData) { 
	   $('#SpecialItemContralDetailTab').datagrid('clearSelections'); //һ��Ҫ������һ�䣬Ҫ��Ȼdatagrid���ס֮ǰ��ѡ��
	   //����ȫѡ
	   //$("#SpecialItemContralDetailTab").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
	
        var UserID=$("#UserID").val();
		if (UserID==""){
			return false;
		} 
		
	    var objtbl = $("#SpecialItemContralDetailTab").datagrid('getRows');
	              
		if (rowData) { 
		   
		  //����datagrid����            
		 $.each(rowData.rows, function (index) {
			 //alert(UserID+"^"+objtbl[index].TItemID)
			 	var flag=tkMakeServerCall("web.DHCPE.SpecialItemContral","GetSpecItemContral",UserID,objtbl[index].TItemID);
			 			if(flag=="Y"){
				 			//����ҳ��ʱ���ݺ�̨�෽������ֵ�ж�datagrid����checkbox�Ƿ񱻹�ѡ
				 		$('#SpecialItemContralDetailTab').datagrid('checkRow',index);
				 		}
		 });
		 
		 
		 }
		}	
			
	});
}
 



