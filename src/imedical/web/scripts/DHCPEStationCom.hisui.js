
//����	DHCPEStationCom.hisui.js
//����	վ��ά��
//����	2019.05.23
//������  xy

$(function(){
		
	InitCombobox();
	
	InitStationDataGrid();
    
    InitStationLocDataGrid(); 
    
    InitStationLocDetailDataGrid();
    //��ѯ
    $('#BFind').click(function(e){
    	BFind_click();
    });
    
     //����
    $('#BClear').click(function(e){
    	BClear_click();
    });
    
    
    //����(վ��)
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�(վ��)
     $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //����(վ���Ӧ����)
     $('#STLadd_btn').click(function(e){
    	STLAdd_click();
    });
    
    //�޸�(վ���Ӧ����)
     $('#STLupdate_btn').click(function(){
    	STLUpdate_click();
    });
    
    //ɾ��(վ���Ӧ����)
     $('#STLdel_btn').click(function(e){
    	STLDel_click();
    });
    
    
     //����(���Ҷ�Ӧ��Ŀ)
     $('#STLDadd_btn').click(function(e){
    	STLDAdd_click();
    });
    
    //�޸�(���Ҷ�Ӧ��Ŀ)
     $('#STLDupdate_btn').click(function(){
    	STLDUpdate_click();
    });
    
    //ɾ��(���Ҷ�Ӧ��Ŀ)
     $('#STLDdel_btn').click(function(e){
    	STLDDel_click();
    });
    
    //����(���Ҷ�Ӧ��Ŀ)
     $('#BSTDClear').click(function(){
    	BSTDClear_click();
    });
    
})



/**************************վ�������ش���********************/
 //��ѯ
function BFind_click()
{
	var iSTActive="N";
	var STActive=$("#STActive").checkbox('getValue');
	if(STActive) {iSTActive="Y";}
	
	$("#StationGrid").datagrid('load',{
			ClassName:"web.DHCPE.Station",
			QueryName:"FindStation",
			aCode:$.trim($("#STCode").val()),
			aDesc:$.trim($("#STDesc").val()),
		    aActive:iSTActive,
		});	
}

//����
function BClear_click()
{
	$("#STCode,#STDesc").val("");
	
}
function AddData()
{
	$("#myWin").show();
	 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'����',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'����',
				id:'save_btn',
				handler:function(){
					SaveForm("")
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		//Ĭ��ѡ��
		$HUI.checkbox("#Active").setValue(true);	
}


SaveForm=function(id)
	{
		
		var Code=$.trim($('#Code').val());
		if (Code=="")
		{
			var valbox = $HUI.validatebox("#Code", {
				required: true,
	   		});
			$.messager.alert('������ʾ','վ����벻��Ϊ��!',"error");
			return;
		}
	     
	    var Desc=$.trim($('#Desc').val());
		if (Desc=="")
		{
			var valbox = $HUI.validatebox("#Desc", {
				required: true,
	   		});
			$.messager.alert('������ʾ','վ����������Ϊ��!',"error");
			return;
		}
		
		var Place=$.trim($('#Place').val());
	
		var Sequence=$.trim($('#Sequence').val());
		
		var iActive="N";
		var Active=$("#Active").checkbox('getValue');
	    if(Active) {iActive="Y";}
	    
	    var iAutoAudit="N";
		var AutoAudit=$("#AutoAudit").checkbox('getValue');
	    if(AutoAudit) {iAutoAudit="Y";}
	  	
	  	var iAllResultShow="N";
		var AllResultShow=$("#AllResultShow").checkbox('getValue');
	    if(AllResultShow) {iAllResultShow="Y";}
	
	
		var LayoutType=$('#LayoutType').combobox('getValue');	
		if (($('#LayoutType').combobox('getValue')==undefined)||($('#LayoutType').combobox('getValue')=="")){var LayoutType="";}
		
		var ButtonType=$('#ButtonType').combobox('getValue');	
		if (($('#ButtonType').combobox('getValue')==undefined)||($('#ButtonType').combobox('getValue')=="")){var ButtonType="";}
	
		
		var ReportSequence=$.trim($('#ReportSequence').val());
		if (ReportSequence=="")
		{
			var valbox = $HUI.validatebox("#ReportSequence", {
				required: true,
	   		});
			$.messager.alert('������ʾ','����˳����Ϊ��!',"error");
			return;
		}
		
		var Instring=id+"^"+Code+"^"+Desc+"^"+Place+"^"+Sequence+"^"+iActive+"^"+iAutoAudit+"^"+LayoutType+"^"+ButtonType+"^"+ReportSequence+"^"+iAllResultShow;
	   
		var flag=tkMakeServerCall("web.DHCPE.Station","Save",'','',Instring);
 		if (""==id) { 
			var Data=flag.split("^");
			flag=Data[0];
		}
	    if(flag==0){
		    $.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		    $("#StationGrid").datagrid('load',{
			    ClassName:"web.DHCPE.Station",
				QueryName:"FindStation",
			
			    }); 
			$('#myWin').dialog('close'); 
	    }else{
		    $.messager.alert('������ʾ',"����ʧ��","error");
	    }
		
	}
	
	
function UpdateData()
{
	var STID=$("#StationID").val();
	if(STID==""){
		$.messager.alert('������ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}
	if(STID!="")
	{	
	      var StaionInfoStr=tkMakeServerCall("web.DHCPE.Station","GetStaionInfoByID",STID);
		   var StaionInfo=StaionInfoStr.split("^");
		   
		   
		   $("#Code").val(StaionInfo[0]);
		   $("#Desc").val(StaionInfo[1]);
		   $("#Sequence").val(StaionInfo[3]);
		   $("#ReportSequence").val(StaionInfo[8]);
		   $("#Place").val(StaionInfo[9]);
		   
		   $('#LayoutType').combobox('setValue',StaionInfo[6]);
		   $('#ButtonType').combobox('setValue',StaionInfo[7]);
		   
		   if(StaionInfo[4]=="Y"){
			    $("#Active").checkbox('setValue',true);
		   }else{
			   $("#Active").checkbox('setValue',false);
		   }
		   
		    if(StaionInfo[5]=="Y"){
			    $("#AutoAudit").checkbox('setValue',true);
		   }else{
			   $("#AutoAudit").checkbox('setValue',false);
		   }
		   
		    if(StaionInfo[10]=="Y"){
			    $("#AllResultShow").checkbox('setValue',true);
		   }else{
			   $("#AllResultShow").checkbox('setValue',false);
		   }
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'�޸�',
				modal:true,
				buttons:[{
					text:'����',
					id:'save_btn',
					handler:function(){
						SaveForm(STID)
					}
				},{
					text:'�ر�',
					handler:function(){
						myWin.close();
					}
				}]
			});							
	}
}


function InitStationDataGrid()
{
	$HUI.datagrid("#StationGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 100,
		pageList : [100,200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"FindStation",
			aCode:"",
			aDesc:"",
		},
		frozenColumns:[[
			{field:'ST_Code',width:'80',title:'վ�����'},
			{field:'ST_Desc',width:'100',title:'վ������'},
		]],
		columns:[[
	
		    {field:'ST_RowId',title:'ID',hidden: true},
			{field:'ST_Active',width:'40',title:'����'},
			{field:'ST_Sequence',width:'80',title:'�ܼ�˳��'},
			{field:'ST_ReportSequence',width:'80',title:'������ʾ˳��'},
			{field:'ST_ButtonType',width:'100',title:'��ť����'},
			{field:'ST_LayoutType',width:'100',title:'��������'},
			{field:'ST_AutoAudit',width:'100',title:'�����Զ��ύ'},
			{field:'ST_AllResultShow',width:'100',title:'�ܼ���ʾ���н��'},
			{field:'ST_Place',width:'150',title:'վ��λ��'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#StationID").val(rowData.ST_RowId);
				$('#StationLocGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadStationLoc(rowData);			
					
		}
		
			
	})

}


/**************************վ���Ӧ���ҽ�����ش���********************/

//ɾ��(վ���Ӧ����)
function STLDel_click()
{	
	var LocID=$("#LocID").val();
	if(LocID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");	
		return false;
		
		}
		
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.StationLoc", MethodName:"Delete",LocID:LocID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#LocID,#LocDesc,#LocSort,#ParRefLocID").val("");
					$('#StationLocGrid').datagrid('load', {
						ClassName:"web.DHCPE.StationLoc",
						QueryName:"SearchStationLoc",
		   				 ParRef:$("#ParRef").val(),
					});	
					$('#StationLocDetailGrid').datagrid('load', {
						ClassName:"web.DHCPE.StationLoc",
						QueryName:"SearchStationLocDetail",
		    			LocID:LocID,
		
					});

     
				}
			});	
		}
	});
	
}

//����(վ���Ӧ����)
function STLAdd_click()
{
	
	STLSave_click("0");
}

//�޸�(վ���Ӧ����)
function STLUpdate_click()
{
	STLSave_click("1");
}

function STLSave_click(Type)
{
	
  	var ParRef=$("#ParRef").val();
	if (ParRef==""){
		$.messager.alert("��ʾ","��ѡ��վ��","info");
		return false;
	}
	if(Type=="0")
	{
		$("#LocID").val("");
	}
	var LocID=$("#LocID").val();
	
	if(Type=="1")
	{ 
		if(LocID==""){
			
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
			
		}
	}
	
	var LocDesc=$("#LocDesc").val();
	if (LocDesc==""){
		$.messager.alert("��ʾ","������������Ϊ��","info",function(){
			var valbox = $HUI.validatebox("#LocDesc", {
			required: true,
	   	});
			$("#LocDesc").focus();
		});
		return false;

	}
	var LocSort=$("#LocSort").val();
	if (LocSort==""){
		$.messager.alert("��ʾ","������Ų���Ϊ��","info",function(){
			var valbox = $HUI.validatebox("#LocSort", {
			required: true,
	   	});
			$("#LocSort").focus();
		});
		return false;

	}else{
		   if((!(isInteger(LocSort)))||(LocSort<=0)) 
		   {
			   $.messager.alert("��ʾ","�������ֻ����������","info");
			    return false; 
		   }

	}


	//alert(ParRef+"^"+LocID+"^"+LocDesc+"^"+LocSort)
	var flag=tkMakeServerCall("web.DHCPE.StationLoc","Update",ParRef,LocID,LocDesc,LocSort);
	if (flag=="0"){
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		$("#LocID,#LocDesc,#LocSort").val("");
		$('#StationLocGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLoc",
		    ParRef:ParRef,
		
		});
	}
	else{
		if(Type=="1"){$.messager.alert("��ʾ","�޸�ʧ��","error");}
		if(Type=="0"){$.messager.alert("��ʾ","����ʧ��","error");}
	}	
}
function loadStationLoc(rowData) {
	
	$('#StationLocGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLoc",
		    ParRef:rowData.ST_RowId,
		
	});
	$("#ParRef").val(rowData.ST_RowId);
	$("#LocID,#LocSort,#LocDesc").val("");
	$("#ARCID,#ARCSort,#ParRefLocID").val("");
	$("#ARCDesc").combogrid("setValue","");

	$('#StationLocDetailGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:"",
		
	});
	
}
function InitStationLocDataGrid()
{
		$HUI.datagrid("#StationLocGrid",{
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
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLoc",
		},
		
		columns:[[
		    {field:'STL_RowId',title:'ID',hidden: true},
			{field:'STL_Desc',width:'100',title:'��������'},
			{field:'STL_Sort',width:'80',title:'�������'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  
				$("#LocID").val(rowData.STL_RowId);
				$("#LocSort").val(rowData.STL_Sort);
				$("#LocDesc").val(rowData.STL_Desc);
				$('#StationLocDetailGrid').datagrid('loadData', {
					total: 0,
					rows: []
				});
			  loadStationLocDetail(rowData);			
								
					
		}
		
			
	})
}
function loadStationLocDetail(rowData) {
	
	$("#ParRefLocID").val(rowData.STL_RowId)
	$('#StationLocDetailGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:rowData.STL_RowId,
		
	});
	

	
}



/**************************���Ҷ�Ӧ��Ŀ������ش���********************/
//����(���Ҷ�Ӧ��Ŀ)
function BSTDClear_click()
{
	
	$("#ARCID,#ARCSort").val("");
	$("#ARCDesc").combogrid("setValue","");
	var valbox = $HUI.combobox("#ARCDesc", {
				required: false,
	    	});
	 InitCombobox();
	$("#STLDadd_btn").linkbutton('enable');
	$('#StationLocDetailGrid').datagrid('load', {
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:$("#ParRefLocID").val(),
		
		});
}


//����(���Ҷ�Ӧ��Ŀ)
function STLDAdd_click()
{
	STLDSave_click("0");
}
    
//�޸�(���Ҷ�Ӧ��Ŀ)
function STLDUpdate_click()
{
	STLDSave_click("1");
}

function STLDSave_click(Type)
{
	if(Type=="0")
	{
		if($("#ARCID").val()!=""){
			$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,��������������","info");
			return false;
			}
		var ARCRowID=$("#ARCDesc").combogrid("getValue");
		if (($("#ARCDesc").combogrid('getValue')==undefined)||($("#ARCDesc").combogrid('getValue')=="")){var ARCRowID="";}
		if (ARCRowID==""){
				var valbox = $HUI.combogrid("#ARCDesc", {
				required: true,
	   		});
			$.messager.alert("��ʾ","��Ŀ����Ϊ��","info");
			return false;
		}
	}
	
	if(Type=="1")
	{ 
	   var ARCRowID=$("#ARCID").val();
		if(ARCRowID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
			
		}
		
	}
	
	
	var Sort=$("#ARCSort").val();
	if (Sort==""){
		$.messager.alert("��ʾ","��Ų���Ϊ��","info",function(){
			var valbox = $HUI.validatebox("#ARCSort", {
			required: true,
	   	});
			$("#ARCSort").focus();
		});

		return false;
	}else{
		   if((!(isInteger(Sort)))||(Sort<=0)) 
		   {
			   $.messager.alert("��ʾ","���ֻ����������","info");
			    return false; 
		   }

	}
	var LocID=$("#ParRefLocID").val();
	if (LocID==""){	
		$.messager.alert("��ʾ","û��ѡ�����","info");
		return false;
	}
	
	
	//alert(ARCRowID+"^"+Sort+"^"+LocID)
	var flag=tkMakeServerCall("web.DHCPE.StationLoc","UpdateDetail",ARCRowID,Sort,LocID);
	if (flag=="0"){
		if(Type=="1"){$.messager.alert("��ʾ","�޸ĳɹ�","success");}
		if(Type=="0"){$.messager.alert("��ʾ","�����ɹ�","success");}
		BSTDClear_click();
		
	}
	else{
		if(Type=="1"){$.messager.alert("��ʾ","�޸�ʧ��","error");}
		if(Type=="0"){$.messager.alert("��ʾ","����ʧ��","error");}
	}	
}    
    
//ɾ��(���Ҷ�Ӧ��Ŀ)
function STLDDel_click()
{

	var ID=$("#ARCID").val();
	if(ID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");	
		return false;
		
		}
	
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.StationLoc", MethodName:"DeleteDetail", ARCIMID:ID},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$('#StationLocDetailGrid').datagrid('load', {
						ClassName:"web.DHCPE.StationLoc",
						QueryName:"SearchStationLocDetail",
		   				 LocID:$("#ParRefLocID").val(),
		
					});
					$("#ARCID,#ARCSort").val("");
					$("#ARCDesc").combogrid("setValue","");
	
			        
				}
			});	
		}
	});
	
}
 
 function InitStationLocDetailDataGrid()
{
		$HUI.datagrid("#StationLocDetailGrid",{
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
			ClassName:"web.DHCPE.StationLoc",
			QueryName:"SearchStationLocDetail",
		    LocID:"",
		},
		
		columns:[[
		    {field:'ArcimID',title:'ID',hidden: true},
			{field:'ARCIMDesc',width:'250',title:'��Ŀ'},
			{field:'TSort',width:'80',title:'���'},
			
		]],
		onSelect: function (rowIndex, rowData) {
			  $("#ARCID").val(rowData.ArcimID);
			  $("#ARCDesc").combogrid("setValue",rowData.ARCIMDesc);
			  $("#ARCSort").val(rowData.TSort);
			  $("#STLDadd_btn").linkbutton('disable');
				
					
		}
		
			
	})
}
   
function InitCombobox()
{ 
	 //��������
	var LayoutTypeObj = $HUI.combobox("#LayoutType",{
		valueField:'id',
		textField:'text',
		panelHeight:'123',
		data:[
            {id:'1',text:'��'},
            {id:'2',text:'��ϸ'},
            {id:'3',text:'��ͨ����'},
            {id:'4',text:'�ӿڻ���'},
            {id:'5',text:'��ͨ���'},
            {id:'6',text:'�ӿڼ��'},
            {id:'7',text:'����'},
            {id:'8',text:'ҩƷ'},
        ]
		});
		
	 //��ť����
	 	var ButtonTypeObj = $HUI.combobox("#ButtonType",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'1',text:'��׼'},
            {id:'2',text:'����'},
            {id:'3',text:'����'},
        ]

		});
		
	
	
	//��Ŀ
	var OrdObj = $HUI.combogrid("#ARCDesc",{
		panelWidth:320,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=QueryAll",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.ParRef = $("#ParRef").val();
			param.ARCIMDesc = param.q;
		},
		onShowPanel:function()
		{
			$('#ARCDesc').combogrid('grid').datagrid('reload');
		},
		columns:[[
		    {field:'STORD_ParRef',title:'վ��ID',hidden: true},
		    {field:'STORD_ParRef_Name',title:'վ��Ŀ������',width:100},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:120},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:100},
			{field:'STORD_ARCIM_DR',title:'ҽ��ID',hidden: true},	
					
		]],
		onLoadSuccess:function(){
			$("#ARCDesc").combogrid('setValue',"")
			
		},

		});
}


function isInteger(num) {
      if (!isNaN(num) && num % 1 === 0) {
        return true;
      } else {
        return false;
      }
	  }

