
//����	DHCPEEDItem.hisui.js
//����	Σ�����ؼ����Ŀά��
//����	2019.06.17
//������  xy

$(function(){
	InitCombobox();
	
	InitEDItemGrid();
	
	InitEDItemDetailGrid();  
	 
    //�޸�
	$("#update_btn").click(function() {	
		BUpdate_click();		
        });
        
     //����
	$("#add_btn").click(function() {	
		BAdd_click();		
        }); 
    
    //ɾ��
	$("#del_btn").click(function() {	
		BDel_click();		
        });   
   
    
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
     
 	//ϸ��ά��
 	$("#Detail_btn").click(function() {	
		BDetail_click();
				
        });
     //����
     $("#BSave").click(function() {	
		BSave_Click();		
        });
     
 
   
})


 //�޸�
function BUpdate_click(){
	BSave_click("1");
}

//����
function BAdd_click(){
	BSave_click("0");
}

function BSave_click(Type)
{
	
	if(Type=="1"){
		var ID=$("#ID").val();
		if(ID==""){
			$.messager.alert("��ʾ","��ѡ����޸ĵļ�¼","info");
			return false;
		}
	}
	
	if(Type=="0"){
	    if($("#ID").val()!=""){
		    	$.messager.alert("��ʾ","�������ݲ���ѡ�м�¼,�����������������","info");
		    	return false;
		    }
	}
	
	var SetsFlag="N";
	
	var ArcimID=$("#ArcimDesc").combogrid('getValue');
	if (($("#ArcimDesc").combogrid('getValue')==undefined)||($("#ArcimDesc").combogrid('getValue')=="")){var ArcimID="";}
	if(Type=="1"){var ArcimID=$("#ArcimID").val();}
	if((ArcimID!="")&&(ArcimID.split("||").length<2)){
		$.messager.alert("��ʾ","��ѡ������Ŀ","info");
		return false;
		  
		    }
	
	if (ArcimID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",ArcimID);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ������Ŀ","info");
				return false;
				}
		}
   
	var SetsID=$("#SetsDesc").combogrid('getValue');
	if (($("#SetsDesc").combogrid('getValue')==undefined)||($("#SetsDesc").combogrid('getValue')=="")){var SetsID="";}
	if(Type=="1"){var SetsID=$("#SetsID").val();}
    if (SetsID!=""){
			var ret=tkMakeServerCall("web.DHCPE.DHCPECommon","IsSets",SetsID);
			if(ret=="0"){
				$.messager.alert("��ʾ","��ѡ���ײ�","info");
				return false;
				}		
		}
	//alert(SetsID+"^"+ArcimID)
	if ((ArcimID=="")&&(SetsID=="")){
			$.messager.alert('��ʾ','��Ŀ���ײͲ���Ϊ��',"info");
			return false;
		}
	if (ArcimID==""){
			SetsFlag="Y";
			ArcimID=SetsID;
	}
	
	var ID=$("#ID").val();
	var Parref=$.trim(selectrow);
	var ExpInfo=$("#ExpInfo").val();
	var Remark=$("#Remark").val();
	
	
	var iNeedFlag="N";
	var iNeedFlag="N";
	var NeedFlag=$("#NeedFlag").checkbox('getValue');
	if(NeedFlag) iNeedFlag="Y";
	
	var iActive="N";
	var Active=$("#Active").checkbox('getValue');
	if(Active) iActive="Y";
	
	var OMETypeDR=$("#OMEType").combogrid('getValue');
	if (($("#OMEType").combogrid('getValue')==undefined)||($("#OMEType").combogrid('getValue')=="")){var OMETypeDR="";}
	
	var flag=tkMakeServerCall("web.DHCPE.Endanger","IsExistItem",$.trim(selectrow),ArcimID)
	if((flag=="1")&&(Type=="0")){
		$.messager.alert("��ʾ","�����Ŀ���ײ��Ѵ��ڣ������ظ�ά��","info");
		return false;
	}
	var Str=Parref+"^"+ArcimID+"^"+iNeedFlag+"^"+OMETypeDR+"^"+SetsFlag+"^"+iActive+"^"+ExpInfo+"^"+Remark;
    //alert(Str)
    
	var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDItemSave",ID,Str);
	var Arr=rtn.split("^");
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ��","error");
		
	}else{
		BClear_click();
		
		if(Type=="1"){$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});}
		if(Type=="0"){$.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}
	}
	
	
	
}

//ɾ��
function BDel_click(){
	var ID=$("#ID").val();
	if (ID=="")
	{
		$.messager.alert("��ʾ","��ѡ���ɾ���ļ�¼","info");
		return false;
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.Endanger", MethodName:"EDItemDelete",ID:ID},function(ReturnValue){
				if (ReturnValue.split("^")[0]=='-1') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					BClear_click();

				}
			});	
		}
	});
	
}

function BClear_click(){
	$("#ID,#ExpInfo,#Remark,#ArcimID").val("");
	$(".hisui-checkbox").checkbox('setValue',true);
	$(".hisui-combogrid").combogrid('setValue',"");

	var valbox = $HUI.validatebox("#Code,#Desc", {
			required: false,
	    });
	$("#EDItemGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDItem",
			Parref:$.trim(selectrow),
		});	
}


function InitCombobox(){
	
	//��Ŀ����
	 var ArcObj = $HUI.combogrid("#ArcimDesc",{
		panelWidth:500,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=StationOrderList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Item = param.q;
		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',hidden: true},
			{field:'STORD_ARCIM_Code',title:'����',width:80},
			{field:'STORD_ARCIM_Desc',title:'����',width:180},	
			{field:'STORD_ARCIM_Price',title:'�۸�',width:100},	
			{field:'TUOM',title:'����',hidden: true}, 
			{field:'TLocDesc',title:'����',width:100},	
			
					
		]]
		});
		
	//�ײ�����
	var SetsObj = $HUI.combogrid("#SetsDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.HandlerOrdSetsEx&QueryName=queryOrdSet",
		mode:'remote',
		delay:200,
		idField:'OrderSetId',
		textField:'OrderSetDesc',
		onBeforeLoad:function(param){
			param.Set = param.q;
			param.Type = "ItemSet";
		},
		columns:[[
		    {field:'OrderSetId',title:'ID',hidden: true},
			{field:'OrderSetDesc',title:'����',width:150},
			{field:'IsBreakable',title:'�Ƿ���',width:100},	
			{field:'OrderSetPrice',title:'�۸�',width:100},	
					
		]]
		});
		
	//�������
	   var OMETypeObj = $HUI.combogrid("#OMEType",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.Endanger&QueryName=OMETypeList",
		mode:'remote',
		delay:200,
		idField:'ID',
		textField:'OMET_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
		},
		columns:[[
		    {field:'ID',title:'ID',hidden: true},
			{field:'OMET_Code',title:'����',width:80},
			{field:'OMET_Desc',title:'����',width:180},	
			{field:'OMET_VIPLevel',title:'VIP�ȼ�',width:100},	
					
		]]
		});
}

function InitEDItemGrid(){
	$HUI.datagrid("#EDItemGrid",{
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
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SearchEDItem",
			Parref:$.trim(selectrow),
		},
		columns:[[
	
		    {field:'TID',title:'ID',hidden: true},
		    {field:'TArcimID',title:'ArcimID',hidden: true},
			{field:'TArcimCode',width:120,title:'��Ŀ����'},
			{field:'TArcimDesc',width:200,title:'��Ŀ����'},
			{field:'TNeedFlag',width:60,title:'����'},
			{field:'TSetsFlag',width:80,title:'�Ƿ��ײ�'},
			{field:'TOMEType',width:150,title:'�������'},
			{field:'TActive',width:60,title:'����'},
			{field:'TExpInfo',width:130,title:'��չ��Ϣ'},
			{field:'TRemark',width:100,title:'��ע'},
			
			
		]],
		onSelect: function (rowIndex, rowData) {
			    $("#ID").val(rowData.TID);
				
				if(rowData.TSetsFlag=="��"){
					
				   // $("#SetsDesc").combogrid('setValue',rowData.TArcimID);
				   $("#SetsDesc").combogrid('setValue',rowData.TArcimDesc);
				    $("#ArcimDesc").combogrid('setValue',"");
				    $("#ArcimID").val("");
				    $("#SetsID").val(rowData.TArcimID);
			    }else{
					$("#ArcimDesc").combogrid('setValue',rowData.TArcimDesc);
					$("#ArcimID").val(rowData.TArcimID);
                    $("#SetsID").val("");
					$("#SetsDesc").combogrid('setValue',"");
			    }

			
				$("#OMEType").combogrid('setValue',rowData.TOMETypeDR);
				$("#ExpInfo").val(rowData.TExpInfo);
				$("#Remark").val(rowData.TRemark);
				if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',false);
				}if(rowData.TActive=="��"){
					$("#Active").checkbox('setValue',true);
				};
				if(rowData.TNeedFlag=="��"){
					$("#NeedFlag").checkbox('setValue',false);
				}if(rowData.TNeedFlag=="��"){
					$("#NeedFlag").checkbox('setValue',true);
				};
				$('#EDItemDetailGrid').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadEDItemDetaill(rowData);	
												
		}
	})
}


/*****************************************ϸ��ά������*************************/

function loadEDItemDetaill(rowData) {
	
	$('#EDItemDetailGrid').datagrid('load', {
		ClassName:"web.DHCPE.Endanger",
		QueryName:"SreachOrderDetailRelate",
		ParRef:rowData.TID,
		ParARCIMDR:rowData.TArcimID,
		
	});
	
	$("#ParRef").val(rowData.TID);
	$("#ParARCIMDR").val(rowData.TArcimID);
     
	
}

function InitEDItemDetailGrid(){

	$HUI.datagrid("#EDItemDetailGrid",{
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
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SreachOrderDetailRelate",
			ParRef:$("#ParRef").val(),
		    ParARCIMDR:$("#ParARCIMDR").val(),
		},
		columns:[[
			{title: 'ѡ��',field: 'Select',width: 70,checkbox:true},
		    {field:'ODR_RowId',title:'ID',hidden: true},
		    {field:'ODR_OD_DR',title:'ODDR',hidden: true},
		    {field:'ODR_Parent_DR',title:'ODPDR',hidden: true},
			{field:'EDItemDetailID',title:'EDItemDetailID',hidden: true},
			{field:'ODR_OD_DR_Code',width:100,title:'ϸ�����'},
			{field:'ODR_OD_DR_Name',width:180,title:'ϸ������'},
			
			
		]],
		
		
	onLoadSuccess: function (rowData) { 
	   $('#EDItemDetailGrid').datagrid('clearSelections'); //һ��Ҫ������һ�䣬Ҫ��Ȼdatagrid���ס֮ǰ��ѡ��
	   //����ȫѡ
	   //$("#SpecialItemContralDetailTab").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
		
	    var objtbl = $("#EDItemDetailGrid").datagrid('getRows');
	              
		if (rowData) { 
		  
		  //����datagrid����            
		 $.each(rowData.rows, function (index) {
			
			 	var flag=tkMakeServerCall("web.DHCPE.Endanger","GetItemDetailChecked",objtbl[index].ODR_OD_DR,$("#ParRef").val());
			 			//alert(flag)
			 			if(flag=="Y"){
				 			//����ҳ��ʱ���ݺ�̨�෽������ֵ�ж�datagrid����checkbox�Ƿ񱻹�ѡ
				 		$('#EDItemDetailGrid').datagrid('checkRow',index);
				 		}
		 });
		 
		 
		 }
		}
		  
	})
}


//����
 function BSave_Click()
 {
	
	 var ParRef=$("#ParRef").val();
	 var ParARCIMDR=$("#ParARCIMDR").val();
	  var str="";

	 var selectrow = $("#EDItemDetailGrid").datagrid("getChecked");//��ȡ�������飬��������
	   var rows = $("#EDItemDetailGrid").datagrid("getRows");
	for(var i=0;i<selectrow.length;i++){
		  	var Active="Y",ExpInfo="",Remark="";
			var ID=rows[i].EDItemDetailID;
			var Active=getColumnValue(i,"Select","EDItemDetailGrid")
			if(Active=="1"){Active="Y";}
			else{Active="N";}

			var DetailID=selectrow[i].ODR_OD_DR;
			var Str=ParRef+"^"+DetailID+"^"+Active+"^"+ExpInfo+"^"+Remark;
			//alert(Str)
			var rtn=tkMakeServerCall("web.DHCPE.Endanger","EDItemDetailSave",ID,Str);
	}
 
	if (rtn.split("^")[0]=="-1"){
		$.messager.alert("��ʾ","����ʧ��","error");

	}
	else {
		$.messager.alert("��ʾ","����ɹ�","success");
		$("#EDItemDetailGrid").datagrid('load',{
			ClassName:"web.DHCPE.Endanger",
			QueryName:"SreachOrderDetailRelate",
			ParRef:ParRef,
			ParARCIMDR:ParARCIMDR,
				});
	}
	
 }
 