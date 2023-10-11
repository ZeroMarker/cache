
/*
 * FileName: dhcpe/ct/orderdetail.js
 * Author: xy
 * Date: 2021-08-13
 * Description: ϸ��ά��
 */
var lastIndex = "";
var EditIndex = -1;
var odstableName = "DHC_PE_OrderDetailSet"; //ϸ����չ��
var tableName = "DHC_PE_OrderDetail"; //ϸ���
var Public_gridsearch1 = [];
var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID'];

$(function(){	
	
	//��ȡ���������б�
	GetLocComp(SessionStr)
	
	//���������б�change
	$("#LocList").combobox({
 	 	onSelect:function(){
	 	 	
	  		BFind_click();
	  		
	  		var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
		    var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		     /********************��Ŀ���¼���****************************/
		   /* $("#ItemDesc").combogrid('setValue',"");
	  		$HUI.combogrid("#ItemDesc",{
				onBeforeLoad:function(param){
					param.ARCIMDesc= param.q;
					param.Type="B";
					param.LocID=LocID;
					param.hospId =hospId;
					param.tableName="DHC_PE_StationOrder" 

				}
		    });
		    
	       $('#ItemDesc').combogrid('grid').datagrid('reload'); 
	       /********************��Ŀ���¼���****************************/
	  			 
  		}
	})
	
	InitCombobox();
	
	//��ʼ�� վ��Grid 
	InitStationGrid();
	 
	 //��ѯ��վ�㣩
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
      
	$("#Desc").keydown(function(e) {	
		if(e.keyCode==13){
			BFind_click();
		}
	});

     
	//��ʼ�� ϸ��Grid 
	InitOrderDetailGrid();
	
	 //��ѯ��ϸ�
	$("#BODFind").click(function() {	
		BODFind_click();		
     });
     
      
	$("#OrdDetailDesc").keydown(function(e) {	
		if(e.keyCode==13){
			BODFind_click();
		}
	});

     //������ϸ�
	$("#BAdd").click(function() {	
		BAdd_click();		
     });
        
    //�޸ģ�ϸ�
	$("#BUpdate").click(function() {	
		BUpdate_click();		
     });
         
      //���棨ϸ�
     $('#BSave').click(function(){
    	BSave_click();
    });
    
     //���ݹ������ң�ϸ�
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
     });
        
	//��ʼ�� ϸ������Grid 
	InitOrderDetailSetGrid();
	     
     //������ϸ�����飩
	$("#BODSAdd").click(function() {	
		BODSAdd_click();		
     });
        
    //�޸ģ�ϸ�����飩
	$("#BODSUpdate").click(function() {	
		BODSUpdate_click();		
     });
             
	// ��׼������
    $("#RelateStandard").click(function() {  
        RelateStandard_click();     
    });
	
	// ��������
    $("#RelateCancel").click(function() {
        RelateCancel_click();
    });
	
	// ��׼������ ������
	$('#gridBTExamItemDetail_search').searchbox({
		searcher:function(value,name){
			//Public_gridsearch1 = searchText($("#gridBTExamItemDetail"),value,Public_gridsearch1);
			
			$('#gridBTExamItemDetail').datagrid('load',{
	                ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QryExamItemDtl",
					aLocID:$("#LocList").combobox('getValue'),
					aAlias:value
	                });
		}
	});
})

//�������ղ���
function RelateCancel_click(){
    var DateID=$("#OrdDetailID").val()
    if (DateID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ���յļ�¼","info"); 
        return false;
    }  
    $.messager.confirm("ȷ��", "ȷ��Ҫ�������ռ�¼��", function(r){
        if (r){
                $.m({
                    ClassName: "web.DHCPE.CT.StatOrderDetail",
                    MethodName: "UpdateOrderDetailEx",
                    ID:DateID,
                    Code: "",
                    Desc: ""
                }, 
                function (rtn) {
                    var rtnArr=rtn.split("^");
                    if(rtnArr[0]=="-1"){    
                        $.messager.alert('��ʾ', $g('��������ʧ��:')+ rtnArr[1], 'error');    
                    }else{  
                        $.messager.alert('��ʾ', '�������ճɹ�', 'success');      
                    }
                    
                    $("#OrderDetailGrid").datagrid('reload');
                });
        }
    })
}

/*******************************ϸ������ start**********************************/
//������ϸ�����飩
function BODSAdd_click()
{
	
  var iStationID=$("#StationID").val();
	if(iStationID=="")
	{
		$.messager.alert('��ʾ','��ѡ��վ��',"info");
		return;		
	}
	var iOrdDetailID=$("#OrdDetailID").val();
	if(iOrdDetailID=="")
	{
		$.messager.alert('��ʾ','��ѡ��ϸ��',"info");
		return;		
	}
	
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
		
		$("#ODStaionDesc").val($("#StaionDesc").val());
		$("#ODSDetailDesc").val($("#DetailDesc").val());
	   	
		//Ĭ��ѡ��
		$HUI.checkbox("#Summary").setValue(true);
		$HUI.checkbox("#NoPrint").setValue(false);	
	    

}

SaveForm=function(id)
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	var iStationID=$("#StationID").val();
	if(iStationID=="")
	{
		$.messager.alert('��ʾ','��ѡ��վ��',"info");
		return;		
	}
	var iOrdDetailID=$("#OrdDetailID").val();
	if(iOrdDetailID=="")
	{
		$.messager.alert('��ʾ','��ѡ��ϸ��',"info");
		return;		
	}
	
	var iSummary="N";
	var Summary=$("#Summary").checkbox('getValue');
	if(Summary) {iSummary="Y";}
	
	var iNoPrint="N";
	var NoPrint=$("#NoPrint").checkbox('getValue');
	if(NoPrint) {iNoPrint="Y";}
	
	var iHistoryFlag="N";
	var HistoryFlag=$("#HistoryFlag").checkbox('getValue');
	if(HistoryFlag) {iHistoryFlag="Y";}

	var iMarried=$('#Married_DR_Name').combobox('getValue');
	if (($('#Married_DR_Name').combobox('getValue')==undefined)||($('#Married_DR_Name').combobox('getValue')=="")){var iMarried="";}
	
	var iZhToEng=$.trim($("#ZhToEng").val());
	
	var iSpecialNature=$.trim($("#SpecialNature").val());
	
	var Instring = iStationID
				+"^"+iOrdDetailID
				+"^"+iSummary
				+"^"+iNoPrint  
				+"^"+iZhToEng
				+"^"+iSpecialNature
				+"^"+iMarried
				+"^"+iHistoryFlag
				;
	 
	 
	var rtn=tkMakeServerCall("web.DHCPE.CT.StatOrderDetail","SaveOrderDetailSet",id,Instring,odstableName,session['LOGON.USERID'],LocID);
	var rtnArr=rtn.split("^");
	if(rtnArr[0]=="-1"){	
		$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');				
	}else{	
		$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		
		$("#OrderDetailSetGrid").datagrid('load',{
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetailSet",
			OrdDetailID:$("#OrdDetailID").val(),	
			LocID:LocID,
			tableName:odstableName
			
		}); 
			   
	   $('#myWin').dialog('close'); 				
	}

	
		
}


//�޸ģ�ϸ�����飩
function BODSUpdate_click()
{

	var ID=$("#OrdDetailSetID").val();
	if(ID==""){
		$.messager.alert('��ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}
	
	$("#ODStaionDesc").val($("#StaionDesc").val());
	$("#ODSDetailDesc").val($("#DetailDesc").val());
	
	if(ID!="")
	{	
	      var OrdDetailSetStr=tkMakeServerCall("web.DHCPE.CT.StatOrderDetail","GetOrdDetailSetByID",ID);
	      
		   var OrdDetailSet=OrdDetailSetStr.split("^");
		  //ODSSummary_"^"_ODSZhToEn_"^"_ODSHistoryFlag_"^"_ODSRange_"^"_ODSMarriedDR_"^"_ODSNoPrint
		   if(OrdDetailSet[0]=="Y"){
			    $("#Summary").checkbox('setValue',true);
		   }else{
			   $("#Summary").checkbox('setValue',false);
		   } 
		 
		    $('#ZhToEng').val(OrdDetailSet[1]);
		    $('#SpecialNature').val(OrdDetailSet[3]);
		    $('#Married_DR_Name').combobox('setValue',OrdDetailSet[4]);
		    if(OrdDetailSet[5]=="Y"){
			    $("#NoPrint").checkbox('setValue',true);
		   }else{
			   $("#NoPrint").checkbox('setValue',false);
		   }
		    if(OrdDetailSet[2]=="Y"){
			    $("#HistoryFlag").checkbox('setValue',true);
		   }else{
			   $("#HistoryFlag").checkbox('setValue',false);
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
						SaveForm(ID)
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


//��ʼ�� ϸ������Grid 
function LoadOrderDetailSetGrid(OrdDetailID){
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
	$("#OrderDetailSetGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetailSet",
		OrdDetailID:OrdDetailID,	
		LocID:LocID,
		tableName:odstableName
	});	
}

function InitOrderDetailSetGrid()
{
	var LocID=session['LOGON.CTLOCID'];
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; };
	
	$HUI.datagrid("#OrderDetailSetGrid",{
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
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetailSet",
			OrdDetailID:$("#OrdDetailID").val(),	
			LocID:LocID,
			tableName:odstableName
			
		},
		frozenColumns:[[
			{field:'TODDesc',width:150,title:'ϸ������'},
		]],
		columns:[[
		
		    {field:'TODSID',title:'ODSID',hidden: true},
			{field:'TODSSequence',title:'ODSSequence',hidden: true},
			{field:'TODSLabtrakCode',title:'ODSLabtrakCode',hidden: true},
			{field:'TODSMarriedDesc',width:90,title:'����'},
			{field:'TODSSummary',width:80,title:'����С��',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TODSAdvice',width:100,hidden: true},
			{field:'TODSNoPrint',width:70,title:'����ӡ',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
			},
			{field:'TODSRange',width:150,title:'���ⷶΧ'},
			{field:'TODSZhToEn',width:120,title:'Ӣ�Ķ���'},
			{field:'TODSExplain',hidden: true},
			{field:'TODSHistoryFlag',width:100,title:'�����жԱ�',align:'center',
				formatter: function (value, rec, rowIndex) {
					if(value=="Y"){
						return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
					}else{
						return '<input type="checkbox" value="" disabled/>';
					}
                        
       			}
	
			},
			{field:'TODSUpdateDate',width:120,title:'��������'},
			{field:'TODSUpdateTime',width:120,title:'����ʱ��'},
			{field:'TODSUpdateUser',width:120,title:'������'}		
			     
		]],
		onSelect: function(rowIndex, rowData) {
			$("#OrdDetailSetID").val(rowData.TODSID)	
					
		}		
	})
	
}


/*******************************ϸ������ end**********************************/


/*******************************ϸ�� start**********************************/
//���ݹ�������
function BRelateLoc_click()
{
	
	var DateID=$("#OrdDetailID").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
   
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
   OpenLocWin(tableName,DateID,SessionStr,LocID,function(){})
   
   $("#OrderDetailGrid").datagrid('reload');
   
}

//��ѯ  ϸ��
function BODFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');

	$("#OrderDetailGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetailNew",
		StationID:$("#StationID").val(),
		Desc:$("#OrdDetailDesc").val(),
		LocID:LocID,
		tableName:tableName
	});	
}

//����
function BAdd_click()
 {
	if($("#StationID").val()==""){
		$.messager.alert('��ʾ', "��ѡ��վ��!", 'info');
		return;
		
	}
	
	$('#OrderDetailGrid').datagrid('getRows').length
	//lastIndex = $('#OrderDetailGrid').datagrid('getRows').length - 1;
	//$('#OrderDetailGrid').datagrid('selectRow', lastIndex);
	$("#OrderDetailGrid").datagrid('clearSelections');
	var selected = $('#OrderDetailGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TODID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#OrderDetailGrid').datagrid('appendRow', {
		TODID: '',
		TODCode: '',
		TODDesc: '',
		TODType: '',
		TODTypeDR: '',
		TODExpression: '',
		TODUnit: '',
		TODSex: '',
		TODSexDR: '',
		TODLabtrakCode: '',
		TODExplain:''
	});
	
	lastIndex = $('#OrderDetailGrid').datagrid('getRows').length - 1;
	$('#OrderDetailGrid').datagrid('selectRow',lastIndex);
	$('#OrderDetailGrid').datagrid('beginEdit',lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	 if($("#StationID").val()==""){
		$.messager.alert('��ʾ', "��ѡ��վ��!", 'info');
		return;
		
	}
	var selected = $('#OrderDetailGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#OrderDetailGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#OrderDetailGrid').datagrid('beginEdit', thisIndex);
		$('#OrderDetailGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#OrderDetailGrid').datagrid('getSelected');

		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODType'  
		});
		$(thisEd.target).combobox('select', selected.TODTypeDR);  
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODCode'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODDesc'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODExpression'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODUnit'  
		});
		
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODSex'  
		});
		$(thisEd.target).combobox('select', selected.TODSexDR);  
			
		var thisEd = $('#OrderDetailGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TODLabtrakCode'  
		});
		
	}
 }

//����
function BSave_click()
{ 
  if($("#StationID").val()==""){
		$.messager.alert('��ʾ', "��ѡ��վ��!", 'info');
		return;
		
	}
	$('#OrderDetailGrid').datagrid('acceptChanges');
	
	var selected = $('#OrderDetailGrid').datagrid('getSelected');
	if (selected==null){
		$.messager.alert('��ʾ', "û����Ҫ���������", 'info');
		return;
	}
	if (selected) {
		
		if (selected.TODID == "") {
			
			if ((selected.TODCode == "undefined")||(selected.TODCode == "")||(selected.TODDesc == "undefined")||(selected.TODDesc == "")||(selected.TODType == "undefined")||(selected.TODType == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				$("#OrderDetailGrid").datagrid('reload');
				return;
			}
			var InString=$("#StationID").val()+"^"+selected.TODCode+"^"+selected.TODDesc+"^"+selected.TODType+"^"+selected.TODExpression+"^"+selected.TODUnit+"^"+selected.TODExplain+"^"+selected.TODSex+"^"+selected.TODLabtrakCode
				
			$.m({
				ClassName: "web.DHCPE.CT.StatOrderDetail",
				MethodName: "SaveOrderDetail",
				ID:'', 
			    InString:InString,
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'),
				UserID:session['LOGON.USERID'],
				Empower:selected.TEmpower
			
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				}

				$("#OrderDetailGrid").datagrid('reload');
			});
		} else {
			$('#OrderDetailGrid').datagrid('selectRow', EditIndex);
			var selected = $('#OrderDetailGrid').datagrid('getSelected');
			if ((selected.TODCode == "undefined")||(selected.TODCode == "")||(selected.TODDesc == "undefined")||(selected.TODDesc == "")||(selected.TODType == "undefined")||(selected.TODType == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				$("#OrderDetailGrid").datagrid('reload');
				return;
			}
			var InString=$("#StationID").val()+"^"+selected.TODCode+"^"+selected.TODDesc+"^"+selected.TODType+"^"+selected.TODExpression+"^"+selected.TODUnit+"^"+selected.TODExplain+"^"+selected.TODSex+"^"+selected.TODLabtrakCode
				
			$.m({
				ClassName: "web.DHCPE.CT.StatOrderDetail",
				MethodName: "SaveOrderDetail",
				ID:selected.TODID, 
			    InString:InString,
				tableName:tableName,
				LocID:$("#LocList").combobox('getValue'),
				UserID:session['LOGON.USERID'],
				Empower:selected.TEmpower
				
				
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');
					
				}else{	
					$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});
					  EditIndex = -1;
					
				}
			   $("#OrderDetailGrid").datagrid('reload');
			});
		}
	}
}

//��ʼ�� ϸ��Grid 
function InitOrderDetailGrid(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$('#OrderDetailGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:OrderDetailColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StatOrderDetail",
			QueryName:"FindOrderDetailNew",
			StationID:$("#StationID").val(),
			Desc:"",
			LocID:LocID,
			tableName:tableName
			
		},
		onSelect: function (rowIndex,rowData) {
			if(rowIndex!="-1"){
				$("#RelateStandard").linkbutton('enable');
				if(rowData.TEmpower=="Y"){		
					$("#BRelateLoc").linkbutton('enable');
				}else{
					$("#BRelateLoc").linkbutton('disable');
				}
				$("#OrdDetailID").val(rowData.TODID);
				$("#DetailDesc").val(rowData.TODDesc);
				
				LoadOrderDetailSetGrid(rowData.TODID);
			}
		},
		onLoadSuccess: function (data) {
			EditIndex = -1;		
		}
	});
	
}
//����  �����б�ֵ
var ODTypeData = [ 
	{id:'T',text:$g('˵����')},
    {id:'N',text:$g('��ֵ��')},
    {id:'C',text:$g('������')},
    {id:'S',text:$g('ѡ����')},
    {id:'A',text:$g('�����ı�')}
];


//�Ա�  �����б�ֵ
var ODSexData = [
 	{id:'M',text:$g('��')},
    {id:'F',text:$g('Ů')},
    {id:'N',text:$g('����')},
];
	

	
var OrderDetailColumns = [[
	{
		field:'TODID', 
		title:'TODID',
		hidden:true
	},{
		field:'TStationName',
		title:'վ��',
		width: 100
	},{
		field:'TODCode',
		width: 80,
		title:'����',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'TODDesc',
		width: 120,
		title:'����',
		sortable: true,
		resizable: true,
		editor: {
			type: 'validatebox',
			options: {
				required: true
			}
		}
	},{
		field:'ItemDtlDesc',
		title:'֪ʶ��ϸ������',
		width: 120
	},{
		field:'TODType',
		title:'����',
		width:80,
		//sortable:true,
		//resizable:true,
		editor: {
			type:'combobox',
			options: {	
				valueField: 'id',
				textField: 'text',
				data: ODTypeData,
				required: true
			}
		}
	},{
		field:'TODSex',
		title:'�Ա�',
		width:70,
		//sortable:true,
		//resizable:true,
		editor: {
			type:'combobox',
			options: {	
				valueField: 'id',
				textField: 'text',
				data: ODSexData
				
			}
		}
   },{
		field:'TODExpression',  
		width: 120,
		title:'���ʽ',
		editor: 'text'
	},{
		field:'TODUnit',
		width: 60,
		title:'��λ',
		editor: 'text'
		
	},{
		field:'TODLabtrakCode',
		width: 120,
		title:'������Ŀ����',
		editor: 'text',
		
	},{
		field:'TODExplain',
		width: 100,
		title:'˵��',
		editor: 'text',
		
	},{
		field: 'TEmpower',
		width: 80,
		title: '������Ȩ',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
					on:'Y',
				off:'N'
			}
						
		}
	},{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	},{
		field:'TUpdateDate',
		title:'��������', 
		width: 120
	},{
		field:'TUpdateTime',
		title:'����ʱ��',
		width: 120
	},{
		field:'TUpdateUser',
		title:'������',
		width: 100
	}
			
]];



function LoadOrderDetailGrid(StationID){
	var LocID=$("#LocList").combobox('getValue')
	$("#OrderDetailGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StatOrderDetail",
		QueryName:"FindOrderDetailNew",
		StationID:StationID,
		LocID:LocID,
		tableName:tableName
	});	
}

/*******************************ϸ�� end**********************************/




/*******************************վ�� start**********************************/

// ��ʼ��վ��ά��DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		
		    {field:'TStationID',title:'ID',hidden: true},
			{field:'TStationCode',title:'����',width: 70},
			{field:'TStationDesc',title:'����',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationSet",
			LocID:LocID,
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			$("#StaionDesc").val(rowData.TStationDesc);
			LoadOrderDetailGrid(rowData.TStationID);
			$("#OrdDetailID").val('');
		
			
			//���վ����Ŀ����Ŀ���������ѡ��
			$("#OrderDetailGrid").datagrid('clearSelections');
			//$("#OrderDetailSetGrid").datagrid('clearSelections');
			 lastIndex = "";
		     EditIndex = -1;
		
		},
		onLoadSuccess: function (data) {
			 //lastIndex = "";
			 //EditIndex = -1;
			
		}
	});
	
}

	

//��ѯ��վ�㣩
function BFind_click(){
	
	var LocID=$("#LocList").combobox('getValue');
	
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:LocID,
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}

/*******************************վ�� end**********************************/
function InitCombobox()
{
	
	//����״�� 
	var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married',
		panelHeight:'95',
	});

}



function RelateStandard_click()
{
	var LocID=$("#LocList").combobox('getValue');
	
    var DateID=$("#OrdDetailID").val()
    if (DateID==""){
        $.messager.alert("��ʾ","��ѡ����Ҫ���յļ�¼","info"); 
        return false;
    }  
    $("#StandardWin").show();
	$("#gridBTExamItemDetail_search").searchbox("setValue",'');
    var StandardWin = $HUI.dialog("#StandardWin", {
        width: 750,
        modal: true,
        height: 450,
        iconCls: '',
        title: '��׼������',
        resizable: true,
        buttonAlign: 'center',
        buttons: [{
            iconCls: 'icon-w-save',
            text: '����',
            id: 'save_btn',
            handler: function() {
                var selected = $('#gridBTExamItemDetail').datagrid('getSelected');
                if (selected==null){
                    $.messager.alert("��ʾ", "��ѡ���׼ϸ�", "info");
                    return false;
                }
                $.m({
					ClassName: "web.DHCPE.CT.StatOrderDetail",
					MethodName: "UpdateOrderDetailEx",
					ID:DateID,
					Code: selected.Code,
					Desc: selected.Desc
                },
				function (rtn) {
					var rtnArr=rtn.split("^");
					if(rtnArr[0]=="-1"){    
						$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');    
					}else{  
						$.messager.alert('��ʾ', '����ɹ�', 'success');      
					}
					
					$("#OrderDetailGrid").datagrid('reload');
					$HUI.dialog("#StandardWin").close();
				});
            }
        }, {
            iconCls: 'icon-w-close',
            text: '�ر�',
            handler: function() {
                $HUI.dialog("#StandardWin").close()

            }
        }],
        onOpen: function() {
			// ��ʼ��DataGrid
			$('#gridBTExamItemDetail').datagrid({
				url:$URL,
				fit : true,
				border : false,
				striped : true,
				fitColumns : false,
				autoRowHeight : false,
				rownumbers:true,
				pagination : true,
				pageSize: 20,
				pageList : [20,100,200],  
				rownumbers : true,  
				singleSelect: true,
				selectOnCheck: true,
				columns: [[
					{ field:'ID', title:'ID', hidden:true }
					,{ field:'Code', width: 100, title:'ϸ�����', sortable: true, resizable: true }
					,{ field:'Desc', width: 200, title:'ϸ������', sortable: true, resizable: true }
					,{ field:'ItemCatDesc', width: 100, title:'��Ŀ����', sortable: true, resizable: true }
					,{ field:'DataFormat', hidden:true, title:'���ݸ�ʽ', sortable: true, resizable: true }
					,{ field:'DataFormatDesc', width: 80, title:'���ݸ�ʽ', sortable: true, resizable: true }
					//,{ field:'Express', width: 200, title:'���ʽ', sortable: true, resizable: true }
					,{ field:'Unit', width: 100, title:'��λ', sortable: true, resizable: true }
					,{ field:'Explain', width: 300, title:'˵��', sortable: true, resizable: true }
				]],
				queryParams:{
					ClassName:"web.DHCPE.KBA.MappingService",
					QueryName:"QryExamItemDtl",
					aLocID:LocID,
					aAlias:""
				},
				onLoadSuccess: function (data) {
					//Public_gridsearch1 = [];
				}
			});
        }
    });
}
