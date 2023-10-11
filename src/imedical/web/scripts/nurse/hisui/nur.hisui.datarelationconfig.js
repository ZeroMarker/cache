var hospComp="",hospID = session['LOGON.HOSPID']
var typeList=[
	{
		value:1,
		label:"������"	
	},
	{
		value:2,
		label:"���鼶��"	
	},
	{
		value:3,
		label:"����״̬"	
	}
];
var sourceList=[
	{
		value:1,
		label:"ҽ��"	
	}
];
$(function() {
	hospComp = GenHospComp("Nur_IP_DataRelationConfig",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;     	
    	reloadDataGrid();
	}  ///ѡ���¼�	
	
	initTable();    
    reloadDataGrid();
    
    // ���
    $HUI.combobox("#type",
	{
		valueField:"value",
		textField:"label",
		data:typeList
	});
	    
    // ������Դ
    $HUI.combobox("#source",
	{
		valueField:"value",
		textField:"label",
		data:sourceList,
		onSelect:function(record){
			if(record.value==1){ // ҽ��
				$('#add-dialog').dialog({height: 288}).dialog("open"); 
				$("#form tr.linkord").show();
				getLinkOrderData("");	
			}else{				
				$('#add-dialog').dialog({height: 246}).dialog("open");	
				$("#form tr.linkord").hide();
				$HUI.combogrid("#linkOrd")			
			}
		},
		onChange:function(record){
			if(!record){
				$('#add-dialog').dialog({height: 246}).dialog("open");	
				$("#form tr.linkord").hide();
				$HUI.combogrid("#linkOrd")	
			}				
		}
	});
})

// ��ʼ��table
function initTable(){
	setDataGrid = $('#dg').datagrid({
		fit : true,
		columns :[[
	    	{field:'desc',title:'����',width:150},  
	    	{field:'code',title:'����',width:150}, 
	    	{field:'arcimcodeS',title:'ҽ��Code��',width:300}, 
	    	{field:'drcType',title:'���',width:150,formatter:function(value,row,index){
		    	var desc="";
		    	typeList.forEach(function(val,key){
			    	if(val.value==value){
				    	desc=val.label;	
				    }	
			    })
	    		return desc;
	    	}},    
	    	{field:'source',title:'������Դ',width:150,formatter:function(value,row,index){
		    	var desc="";
		    	sourceList.forEach(function(val,key){
			    	if(val.value==value){
				    	desc=val.label;	
				    }	
			    })
	    		return desc;
	    	}},    
		]],
		rownumbers:true,
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
	                $('#add-dialog').dialog({height: 246,title:"�������ݹ�ϵ����"}).dialog("open");	
	                $('#form').form("clear");
					$("#form tr.linkord").hide();
					$HUI.combogrid("#linkOrd")		
	            }
			},
			{
	            iconCls: 'icon-write-order',
	            text: '�޸�',
	            handler: function () {
	                updateData();
	            }
	        },{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	delData();
            	}
         	},{
	            text: '����',
	            iconCls: 'icon-translate-word',
	            handler: function() {
		            Translate("dg","CT.NUR.NIS.DataRelationConfig","DRCDesc","desc")	
	            }
	        }
        ],
		pagination : true,  //�Ƿ��ҳ
		pageSize: 15,
		pageList : [15,30,50],
		singleSelect : true,
		loadMsg : '������..' 
	});  
}

// �б����ݼ���
function reloadDataGrid()
{
	$.cm({
		ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
		QueryName:"GetDataRelationList",
		hospDR:hospID,
		category:"",
		rows:99999
	},function(data){
		setDataGrid.datagrid({loadFilter:pagerFilter}).datagrid('loadData',data); 
	})
}

// ��ȡ����ҽ���б�
function getLinkOrderData(arcimCodeS,arcimDescS) {	
	//ҽ������
	$HUI.combogrid("#linkOrd", {
		panelWidth: 520,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'ArcimCode',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimCode',title:'��ĿCode',width:50}
		]],
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		multiple:true,
		onBeforeLoad:function(param){
			if(arcimDescS){
				param['q']=arcimDescS;
				arcimDescS=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){
			if(arcimCodeS){
	            $(this).combogrid('setValues', arcimCodeS.split("^"));
	            arcimCodeS="";     
	        }
		}
	});
}

// �޸�ѡ�е���������ʱ�����ݻ���
function updateData(){	
	var rows=$('#dg').datagrid("getSelections");
	if (rows.length == 1) {
   		$("#add-dialog").dialog("open");
   		if(rows[0].source==1){
	   		$('#add-dialog').dialog({height: 288,title:"�޸����ݹ�ϵ����"}).dialog("open"); 
			$("#form tr.linkord").show();
	   		getLinkOrderData(rows[0].arcimcodeS,rows[0].arcimDescS)
	   	} 		
	   	$('#form').form("clear");
	 	$('#form').form("load",{
	 		Rowid: rows[0].rowid,
	 		Desc: rows[0].desc,
	 		Code: rows[0].code,
	 		Type: rows[0].drcType,
	 		Source: rows[0].source
 		}); 			
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫ�޸ĵ���������", "info");
 	}
}

function saveData(){
	var rowid=$.trim($("#rowid").val());
	var desc=$.trim($("#desc").val());
	var code=$.trim($("#code").val());
	var type=$("#type").combobox('getValue');
	var source=$("#source").combobox('getValue');
	var arcimCode=[];
	if(source==1){
		arcimCode=$HUI.combogrid('#linkOrd').getValues();	
	}		
	if(code == "")
	{
		$.messager.popover({ msg: '���벻��Ϊ�գ�', type:'error' });
    	return false;
	}
	if(type == "")
	{
		$.messager.popover({ msg: '�����Ϊ�գ�', type:'error' });
    	return false;
	}
	if(source==1 && arcimCode.length==0)
	{
		$.messager.popover({ msg: '����ҽ������Ϊ�գ�', type:'error' });
    	return false;
	}
	$.m({
		ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
		MethodName:"SaveData",
		"rowid":rowid,
		"desc":desc,
		"code":code,
		"type":type,
		"source":source,
		"arcimCodeS":arcimCode.length==0 ? "" : arcimCode.join("^"),
		"hospDR":hospID
	},function testget(result){		
		if(result == "0"){	
			$('#add-dialog').dialog("close");			
			$.messager.popover({msg:"����ɹ���", type:'success'});			
			reloadDataGrid();						
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
		}
	});	
}

// ɾ��ѡ�е���������
function delData(){	
	var rows=$('#dg').datagrid("getSelections");
	if (rows.length == 1) {
		$.messager.confirm("����ʾ", "ȷ��Ҫɾ��������������", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.Base.DataRelationConfig",
					MethodName:"DeleteConfig",
					"rowid":rows[0].rowid
				},function testget(result){
					if(result == "0"){
						$.messager.popover({msg:"ɾ���ɹ���", type:'success'});			
						reloadDataGrid();						
					}else{	
						$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });	
					}
				}); 
			}
		});				
 	}else{
    	$.messager.alert("����ʾ", "��ѡ��Ҫɾ������������", "info");
 	}
}

// ����
function Translate(tableId,className,fieldName,key){
	var selectedRow=$("#"+tableId).datagrid("getSelections");
	if(selectedRow.length>0){
		CreatTranLate(className,fieldName,selectedRow[0][key]);
	}else{
		$.messager.popover({msg:'��ѡ��Ҫ��������ݣ�',type:'alert'});
	}		
}