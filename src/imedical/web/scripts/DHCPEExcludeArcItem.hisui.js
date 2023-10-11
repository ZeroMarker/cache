
//����	DHCPEExcludeArcItem.hisui.js
//����	�ų���Ŀά��
//����	2021.03.18
//������  xy

$(function(){
	
	//��ʼ�������б�
  	InitCombobox();
	
	//��ʼ��վ��Grid		
	InitStationDataGrid();
	
	//��ʼ����ĿGrid		
	InitOrderTabDataGrid();
	
	//��ʼ���ų���ĿGrid				
	InitExcludeArcItemGrid();
	
	//��ѯ
	$("#BFind").click(function(e){
    	BFind_click();
    });
	
	$("#ARCIMDesc").keydown(function(e) {
			
		if(e.keyCode==13){
				BFind_click();
				}
		});

	
	
	//����
	$("#BAdd").click(function(e){
    	BSave_click("0");
    });
	
	
	//�޸�
	$("#BUpdate").click(function(e){
    	BSave_click("1");
    });
    
	//ɾ��
	$("#BDelete").click(function(e){
    	BDelete_click();
    });
    
    
    //����
	$("#BClear").click(function(e){
    	BClear_click();
    });

	info();
	
})


function info()
{
	var ID=$("#ID").val()
	if(ID==""){
		$("#BAdd").linkbutton('enable');
		$("#BUpdate").linkbutton('disable');
		$("#BDelete").linkbutton('disable');
	}else{
		$("#BAdd").linkbutton('disable');
		$("#BUpdate").linkbutton('enable');
		$("#BDelete").linkbutton('enable');
	}
	
}


/**********************�Ų���Ŀ start************************************/

//ɾ��
function BDelete_click()
{
	var RowId=$("#ID").val();
	if (RowId=="")
	{
		$.messager.alert("��ʾ","����ѡ���ɾ���ļ�¼","info");	
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.ExcludeArcItem", MethodName:"DeleteExcludeArcItem",ID:RowId},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					BClear_click()
				}
			});	
		}
	});
	
		
}

//����
function BSave_click(Type){
	var ARCIMRowID=$("#ARCIMRowID").val();
	if(ARCIMRowID==""){
		$.messager.alert("��ʾ","��ѡ���ά������Ŀ","info");
		return false;
		
	}
	var ExcludeARCIMID=$("#ExcludeARCIMDesc").combogrid('getValue');
	if (($("#ExcludeARCIMDesc").combogrid('getValue')==undefined)||($("#ExcludeARCIMDesc").combogrid('getText')=="")){var ExcludeARCIMID="";}
	if(ExcludeARCIMID==""){
		$.messager.alert("��ʾ","��ѡ����ų����Ŀ","info");
		return false;
		
	}

	if(ARCIMRowID==ExcludeARCIMID){
		$.messager.alert("��ʾ","�ų����Ŀ��ά����Ŀ������ͬ","info");
		return false;
	}

	var flag=tkMakeServerCall("web.DHCPE.ExcludeArcItem","IsExcludeArcItem",ARCIMRowID,ExcludeARCIMID);
	if(flag=="1"){
		$.messager.alert("��ʾ","�Ѵ��ڸ��ų���Ŀ","info");
		return false;
		
	}
	
	var ID=$("#ID").val();
	var rtn=tkMakeServerCall("web.DHCPE.ExcludeArcItem","SaveExcludeArcItem",ID,ARCIMRowID,ExcludeARCIMID);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		
		if(Type=="0"){$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});}
		BClear_click();
	}else{
		$.messager.alert("��ʾ",Arr[1],"error");	
	} 	
	
}

//����
function BClear_click()
{
	$("#ID").val("");
	$("#ExcludeARCIMDesc").combogrid('setValue',"");
	 InitCombobox();
	$("#ExcludeArcItemGrid").datagrid('load',{
			ClassName:"web.DHCPE.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val()
	});	
	
	info();
}	

function InitExcludeArcItemGrid()
{
	$HUI.datagrid("#ExcludeArcItemGrid",{
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
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
		},
		columns:[[
		    {field:'id',title:'ID',hidden: true},
			{field:'ExArcItemDesc',width:270,title:'�ų���Ŀ'}		
		]],
		onSelect: function (rowIndex, rowData) {
			$("#ID").val(rowData.id)
			$("#BAdd").linkbutton('disable');
			$("#BUpdate").linkbutton('enable');
			$("#BDelete").linkbutton('enable');

			//$("#ExcludeARCIMDesc").combogrid('disable');			
		}	
			
	})

}
function LoadExcludeArcItemGrid(rowData)
{
	
	$("#ARCIMRowID").val(rowData.ODR_ARCIM_DR);
	
	$("#ExcludeArcItemGrid").datagrid('load', {
			ClassName:"web.DHCPE.ExcludeArcItem",
			QueryName:"FindExcludeArcItem",
			ARCIMID:$("#ARCIMRowID").val()
		
	});
	
}
/**********************�ų���Ŀ end************************************/


/**********************��Ŀ���� start************************************/
function LoadOrderTabTablist(rowData)
{
	
	$("#ParRef").val(rowData.ST_RowId);
	
	$("#OrderTab").datagrid('load', {
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		
	});

   $("#ARCIMRowID").val("");
   BClear_click();

	
	
}
function InitOrderTabDataGrid()
{
	
	$HUI.datagrid("#OrderTab",{
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
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		toolbar: [],//������toolbarΪ��ʱ,���ڱ�������ͷ�������"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			hospId:session['LOGON.HOSPID']
		},
		columns:[[

		    {field:'ODR_ARCIM_DR:',title:'ID',hidden: true},
		    {field:'ODR_ARCIM_DR_Name',width:'200',title:'��Ŀ����'},
			{field:'ODR_ARCIM_Code',width:'70',title:'��Ŀ����'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#ExcludeArcItemGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadExcludeArcItemGrid(rowData);
					
		}
		
			
	})
}

 function BFind_click()
{
	
	$("#OrderTab").datagrid('load',{
			ClassName:"web.DHCPE.OrderDetailRelate",
			QueryName:"OrderDetailRelateList",
			ParRef:$('#ParRef').val(),
			Desc:$("#ARCIMDesc").val(),
			hospId:session['LOGON.HOSPID']
		}); 

}  
/**********************��Ŀ���� end************************************/


/**********************վ����� start************************************/
function InitStationDataGrid()
{
	
	$HUI.datagrid("#StationTab",{
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
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		toolbar: [],//������toolbarΪ��ʱ,���ڱ�������ͷ�������"
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',width:70,title:'վ�����'},
			{field:'ST_Desc',width:170,title:'վ������'},			
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#OrderTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadOrderTabTablist(rowData);
		
					
		}
		
			
	})

}

/**********************վ����� end************************************/

function InitCombobox(){
	
		
		//ҽ������
	var ARCIMDObj = $HUI.combogrid("#ExcludeARCIMDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',width:40},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:200},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:150},			
		]],
		onLoadSuccess:function(){
			
		},
	});
	}