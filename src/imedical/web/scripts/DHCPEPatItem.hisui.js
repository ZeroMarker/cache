
//����	DHCPEPatItem.hisui.js
//����	���ﵥ˳������
//����	2019.05.08
//������  xy

$(function(){
		
	InitCombobox();
	
	InitPatItemDataGrid();
    
    InitPatItemlistDataGrid(); 
    
     
      //�޸�(���ﵥ�������)
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
        
     //����(���ﵥ�������)
	$("#BAdd").click(function() {	
		BAdd_click();		
        });  
     
        
    //ɾ��(���ﵥ�������)
	$("#BDelete").click(function() {	
		Delete_Click();		
        });
      
    //����(���ﵥ�������)
	$("#BClearP").click(function() {	
		BClearP_click();		
        });
     
       
      //�޸�(���ﵥ����)
	$("#BUpdateL").click(function() {	
		BUpdateL_click();		
        });
        
     //����(���ﵥ����)
	$("#BAddL").click(function() {	
		BAddL_click();		
        }); 
     //����(���ﵥ����)
	$("#BClearL").click(function() {	
		BClearL_click();		
        });
   
})

//�޸�(���ﵥ�������)
function BUpdate_click()
{  
	 Update("0");
}

//����(���ﵥ�������)
function BAdd_click()
{
	 Update("2");
}
 


//ɾ��
function Delete_Click()
{
	var RowID=$("#PID").val();
	if(RowID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");	
		return false;
		
		}
	Update("1");
	
}


function Update(Type)
{
	
	if(Type=="0"){
		var RowID=$("#PID").val();
		if(RowID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	if(Type=="2"){
	    if($("#PID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		var RowID="";
	}
	
	var AutoChange="N",Reporttype="PatItem",AutoChange="N";
	var RowID=$("#PID").val();
	
	var Name=$("#Name").val();
	if (""==Name) {
		$("#Name").focus();
		var valbox = $HUI.validatebox("#Name", {
			required: true,
	    });
		$.messager.alert("��ʾ","�����Ϊ��","info");
		return false;
	}
	
	var Sort=$("#Sort").val();
	if (""==Sort) {
		$("#Sort").focus();
		var valbox = $HUI.validatebox("#Sort", {
			required: true,
	    });
		$.messager.alert("��ʾ","˳����Ϊ��","info");
		return false;
	}
	var Place=$("#Place").val();
	
	var iIFDocSign="N"
	var IFDocSign=$("#IFDocSign").checkbox('getValue');
	if(IFDocSign) iIFDocSign="Y";
	
	var iPatSignName="N"
	var PatSignName=$("#PatSignName").checkbox('getValue');
	if(PatSignName) iPatSignName="Y";
	
	var Strs=Name+"^"+Sort+"^^"+AutoChange+"^"+Place+"^"+iIFDocSign+"^"+iPatSignName;
	
	if(Type=="1"){
		$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.SetPatItem", MethodName:"Update",RowID:RowID,Strs:Strs,isDel:Type,Type:Reporttype},function(ReturnValue){
			if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					BClearP_click();
					BClearL_click();
					    
				}
			});	
		}
	});
		
	}else{
		var flag=tkMakeServerCall("web.DHCPE.SetPatItem","Update",RowID,Strs,Type,Reporttype);
		
	if(flag==0){
		BClearP_click();
	
		if(Type=="0"){
			$.messager.alert("��ʾ","�޸ĳɹ�","success");	
		}
		if(Type=="2"){
			$.messager.alert("��ʾ","�����ɹ�","success");	
		}
		
	}
	}
	
	
	//���
	  var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatItem&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
		
}

//�޸�(���ﵥ����)
function BUpdateL_click()
{  
	 BSaveL_click("1");
}

//����(���ﵥ����)
function BAddL_click()
{
	BSaveL_click("0");
}
 
//����(���ﵥ����)
function BSaveL_click(Type)
{
	
	if(Type=="1"){
		var ARCIMID=$("#LID").val();
		var ARCIMIDNew=$("#ARCIMDesc").combogrid('getValue');
		
		if(ARCIMID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
		
		if((ARCIMIDNew!=ARCIMID)&&(ARCIMIDNew.indexOf("||")>0)){
				$.messager.alert("��ʾ","�����µ�ҽ��������","info");
			return false;
		}
	}
	
    if(Type=="0"){
	    if($("#LID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
		
		var ARCIMID=$("#ARCIMDesc").combogrid('getValue');
		if (($("#ARCIMDesc").combogrid('getValue')==undefined)||($("#ARCIMDesc").combogrid('getValue')=="")){var ARCIMID="";}
		if (ARCIMID==""){
			var valbox = $HUI.validatebox("#ARCIMDesc", {
				required: true,
	    	});
			$.messager.alert("��ʾ","ҽ�����Ʋ���Ϊ��","info");
			return false
		}
		if (ARCIMID.indexOf("||")<0){
			$.messager.alert("��ʾ","��ѡ��ҽ������","info");
			return false
		}

	}
	
	var PatItem=$("#PatItemName").combobox('getValue');
	if (PatItem==""){
		var valbox = $HUI.validatebox("#PatItemName", {
			required: true,
	    });
		$.messager.alert("��ʾ","�����Ϊ��","info");
		return false
	}
	
	
	var Sort=$("#SortL").val();
	
	var iPrintFlag="N";
	var PrintFlag=$("#PrintFlag").checkbox('getValue');
	if(PrintFlag)iPrintFlag="Y";
	
	var PrintName=$("#PrintName").val();
	
	
	var Str=PatItem+"^"+Sort+"^"+iPrintFlag+"^"+PrintName;
	
	if(Type=="1"){
		   var ret=tkMakeServerCall("web.DHCPE.SetPatItem","UpdateItemInfo",ARCIMID,Str);
			$.messager.alert("��ʾ","�޸ĳɹ�","success"); 
				BClearL_click();
		}
	if(Type=="0"){
		var flag=tkMakeServerCall("web.DHCPE.SetPatItem","IsExsitPatItem",ARCIMID);
			$.messager.confirm("ȷ��", "��ҽ���ѹ������ﵥ���ȷ��Ҫ�޸���", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.SetPatItem", MethodName:"UpdateItemInfo",ARCIMID:ARCIMID,Str:Str},function(ReturnValue){
			if (ReturnValue=='0') {
					$.messager.alert("��ʾ","�����ɹ�","success"); 
						BClearL_click();
					
				}
			}); 
		}
	});
			
		}
			
	
}



//����(���ﵥ����)
function BClearP_click()
{ 
	$("#PID,#Name,#Sort,#Place").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	var valbox = $HUI.validatebox("#Name,#Sort", {
		required: false,
	  });
	$("#PatItemTab").datagrid('load',{
			ClassName:"web.DHCPE.SetPatItem",
			QueryName:"SetPatItem",
		});

	
} 

//����(���ﵥ����)
function BClearL_click()
{
	$("#LID,#PrintName,#SortL").val("");
	$(".hisui-checkbox").checkbox('setValue',false);
	$("#Station").combobox('setValue',"");
	$("#ARCIMDesc").combogrid('setValue',"");
	/*
	var valbox = $HUI.validatebox("#PatItemName,#ARCIMDesc", {
			required: false,
	    });	
	    */
	var PatItem=$("#PatItemName").combobox('getValue');
     $('#PatItemName').combobox('setValue',PatItem);
    
	$('#PatItemlistTab').datagrid('load', {
		ClassName: 'web.DHCPE.SetPatItem',
		QueryName: 'SetPatItemListNew',
		PatItemName: PatItem,
		
	});
	
	
	
} 

function InitCombobox()
{
	  //վ��
	  var StationObj = $HUI.combobox("#Station",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationBase&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onChange:function()
		{
			OrdObj.clear();
			
		},
		});

	 //���
	  var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatItem&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	
	
	//��Ŀ
	var OrdObj = $HUI.combogrid("#ARCIMDesc",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=QueryAll",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.ParRef = $("#Station").combobox('getValue');
			param.ARCIMDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#ARCIMDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
		   {field:'STORD_ParRef',title:'վ��ID',hidden: true},
		    {field:'STORD_ParRef_Name',title:'վ��',width:100},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:120},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:100},
			{field:'STORD_ARCIM_DR',title:'ҽ��ID',hidden: true},
					
		]]
		});
}

function InitPatItemDataGrid()
{
	$HUI.datagrid("#PatItemTab",{
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
			ClassName:"web.DHCPE.SetPatItem",
			QueryName:"SetPatItem",
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
			{field:'TName',width:150,title:'���'},
			{field:'TSort',width:40,title:'˳��'},
			{field:'TIFDocSign',width:80,title:'ҽ��ǩ��'},
			{field:'TPatSignName',width:80,title:'����ǩ��'},
			{field:'TPlace',width:300,title:'λ��'},
			

			
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#PID").val(rowData.TID);
				$("#Name").val(rowData.TName);
				$("#Sort").val(rowData.TSort);
				$("#Place").val(rowData.TPlace);
				
				if(rowData.TIFDocSign=="��"){
					$("#IFDocSign").checkbox('setValue',false);
				}if(rowData.TIFDocSign=="��"){
					$("#IFDocSign").checkbox('setValue',true);
				};
				if(rowData.TPatSignName=="��"){
					$("#PatSignName").checkbox('setValue',false);
				}if(rowData.TPatSignName=="��"){
					$("#PatSignName").checkbox('setValue',true);
				};
				
							
			$('#PatItemlistTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadPatItemlist(rowData);			
					
		}
		
			
	})

}

function loadPatItemlist(row) {
	
	$('#PatItemlistTab').datagrid('load', {
		ClassName: 'web.DHCPE.SetPatItem',
		QueryName: 'SetPatItemListNew',
		PatItemName: row.TID,
		
	});
	
	$('#PatItemName').combobox('setValue',row.TID);
	$("#LID,#PrintName,#SortL").val("");
	$("#PrintFlag").checkbox('setValue',false);
	$("#Station").combobox('setValue',"");
	$("#ARCIMDesc").combogrid('setValue',"");

}

function InitPatItemlistDataGrid()
{
		$HUI.datagrid("#PatItemlistTab",{
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
			ClassName: 'web.DHCPE.SetPatItem',
			QueryName: 'SetPatItemListNew',
		},
		columns:[[
	
		    {field:'TARCIMID',title:'ID',hidden: true},
			{field:'STRowId',title:'STRowId',hidden: true},
			{field:'TARCIMDesc',width:250,title:'ҽ������'},
			{field:'TPrintName',width:250,title:'��ӡ����'},
			{field:'TSort',width:50,title:'���'},
			{field:'TPrintFlag',width:40,title:'��ӡ'},
	
		]],
		onSelect: function (rowIndex, rowData) {
			    $("#Station").combobox('setValue',rowData.STRowId);
				$("#ARCIMDesc").combogrid('setValue',rowData.TARCIMDesc);
				$("#PrintName").val(rowData.TPrintName);
				$("#SortL").val(rowData.TSort);
				$("#LID").val(rowData.TARCIMID);
				
				if(rowData.TPrintFlag=="��"){
					$("#PrintFlag").checkbox('setValue',false);
				}if(rowData.TPrintFlag=="��"){
					$("#PrintFlag").checkbox('setValue',true);
				};							
		}
		
			
	})

}


