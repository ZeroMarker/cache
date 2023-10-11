var flag=0;
$(function() {
	hospComp = GenHospComp("Nur_IP_DHCNurFaYaoTimeSet",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		console.log(arguments);
		hospID=d.HOSPRowId; 
		getLinkWardData(); 
		getPharmacyData();	
		reloadDataGrid();
	}  ///ѡ���¼�	
	initUI();
})

///��ʼ��ҳ��
function initUI(){
	getLinkWardData();
	getPharmacyData();
	initTable();
	reloadDataGrid();
}
// �����б�
function getLinkWardData(locId,locDesc){
	$.q({
	    ClassName : "Nur.NIS.Service.DrugAudit.Setting",
	    QueryName : "LookupCTLoc",
	    LocDesc:"",
	    HospitalRowId:$HUI.combogrid('#_HospList').getValue(),
	    rows:99999
	},function(GridData){
		$("#linkWard").combobox({   
			valueField:'CTLocId',   
    		textField:'CTLocDesc',
    		data:GridData['rows'],
    		filter: function(q, row){
				if (q=="") return true;
				if (row["CTLocDesc"].indexOf(q.toUpperCase())>=0) return true;
				var find=0;
				for (var i=0;i<row["LocAlias"].split("^").length;i++){
					if ((row["LocAlias"].split("^")[i].toUpperCase()).indexOf(q.toUpperCase()) >= 0){
						find=1;
						break;
					}
				}
				if (find==1) return true;
				return false;
			}
		})
	});
}
function getPharmacyData(){
	$.cm({
	    ClassName : "Nur.IP.DrugAudit",
	    MethodName : "getPharmacy",
	    HospID:$HUI.combogrid('#_HospList').getValue()
	},function(data){
		$("#pharmacy").combobox({   
			valueField:'ID',   
    		textField:'desc',
    		data:data
		})
	});
}
// ��ʼ���б�
function initTable(){
	var toolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
            	flag=0;
                ShowDrugAuditTimeSetWin(flag);
            }
        },{
	        text: '�޸�',
	        iconCls: 'icon-edit',
	        handler: function() {
		        var row=$("#dg").datagrid("getSelections");
			   	if(row.length==0){
				   return $.messager.popover({ msg: "��ѡ��Ҫ�޸ĵ����ݣ�", type:'error'});		
				}
	            flag=1;
	            setDrugAuditTimeSetData(row[0]);
                ShowDrugAuditTimeSetWin(flag);
	        }
	   },{
	        text: 'ɾ��',
	        iconCls: 'icon-cancel',
	        handler: function() {
	            delTimeSet();
	        }
	   }
	];
	$("#dg").datagrid({
		fit:true,
		toolbar :toolBar,
		columns :[[
	    	//{field:'id',title:'ID',width:100},  
	    	//{field:'Ward',title:'����ID',width:100}, 
	    	{field:'WardDesc',title:'����',width:300},
	    	{field:'pharmacy',title:'ҩ��',width:150},
	    	{field:'SDate',title:'��ʼ����',width:100}, 
	    	{field:'STime',title:'��ʼʱ��',width:100}, 
	    	{field:'EDate',title:'��ֹ����',width:100}, 
	        {field:'ETime',title:'��ֹʱ��',width:100} 
		]],
		singleSelect : true,
		loadMsg : '������..',
		onDblClickRow:function(rowIndex,rowData){
			flag=1;
			setDrugAuditTimeSetData(rowData);
			ShowDrugAuditTimeSetWin(flag);
		}
	});
}
function reloadDataGrid(){
	var searchType=$("#searchType").combobox("getValue");
	var searchContent=$.trim($("#searchContent").val());
	//var wardID=$("#linkLoc").combobox("getValue");
	//var endTime=$("#endTime").timespinner('getValue');
	$.cm({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		QueryName:"GetDrugAuditTimeSetList",
		hospID:hospID, 
		searchType:searchType, 
		searchContent:searchContent,
		rows:99999
	},function(data){
		$("#dg").datagrid('loadData',data); 
	}) 
}

// ��������
function saveTimeSet(){
   	var id="",wardID="",medTyp="",startDate="",startTime="",endDate="",endTime="",pharmacy="";
   	var row=$("#dg").datagrid("getSelections");
   	if(flag){ //�޸�
	   	if(row.length==0){
		   return $.messager.popover({ msg: "��ѡ��Ҫ�޸ĵ����ݣ�", type:'info'});		
		}
		id=row[0].id;	
	}
	wardID=$("#linkWard").combobox("getValue");
	pharmacy=$("#pharmacy").combobox("getValue");
	startDate=$.trim($("#startDate").numberbox("getValue"));
	startTime=$("#startTime").timespinner('getValue');
	endDate=$.trim($("#endDate").numberbox("getValue"));
	endTime=$("#endTime").timespinner('getValue');
	if ((wardID=="")&&(pharmacy=="")){
		return $.messager.popover({ msg: "���Һ�ҩ������ͬʱΪ�գ�", type:'error'});
	}
	if(startDate=="" || startTime=="" || endDate=="" ||endTime==""){
		return $.messager.popover({ msg: "��ʼ����ֹʱ�䲻��Ϊ�գ�", type:'error'});
	}	
	var parr=id+"^"+wardID+"^"+medTyp+"^"+endDate+"^"+endTime+"^"+startDate+"^"+startTime+"^"+pharmacy;
	$.m({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		MethodName:"SaveTimeSet",
		parr:parr,
		HospID:hospID
	},function testget(result){	
		if(result==0){
			flag=0;
			$.messager.popover({ msg: "����ɹ���", type:'success'});
			$('#drugAuditTimeSetWin').window("close");
			//reloadDataGrid();	
		}else{
			$.messager.popover({ msg: result, type:'error'});
		}		
	});
}
// ɾ������
function delTimeSet(){
   	var row=$("#dg").datagrid("getSelections");
   	if(row.length==0){
	   return $.messager.popover({ msg: "��ѡ��Ҫɾ�������ݣ�", type:'info'});		
	}
	$.m({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		MethodName:"DelTimeSet",
		id:row[0].id
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "ɾ���ɹ���", type:'success'});
			reloadDataGrid();	
		}else{
			$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error'});
		}		
	});
}
function ShowDrugAuditTimeSetWin(flag){
	$('#drugAuditTimeSetWin').window({
		title: flag?'�޸�':'����',
		zIndex:9999,
		iconCls:flag?'icon-w-edit':'icon-w-add',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true,
		closed:false,
		onBeforeClose:function(){
			clearDrugAuditTimeSetData();
			reloadDataGrid();
		}			
	});
}
function clearDrugAuditTimeSetData(){
	$("#linkWard,#pharmacy").combobox("setValue","").combobox("setText","");
	//getLinkWardData(); 
	//getPharmacyData();
	$("#startDate,#endDate").numberbox("setValue","");
	$("#startTime,#endTime").timespinner("setValue","");
}
function setDrugAuditTimeSetData(row){
	$("#linkWard").combobox("setValue",row.Ward);
	$("#pharmacy").combobox("setValue",row.pharmacyDr);
	$("#startDate").numberbox("setValue",row.SDate);
	$("#endDate").numberbox("setValue",row.EDate);
	$("#startTime").timespinner("setValue",row.STime);
	$("#endTime").timespinner("setValue",row.ETime);
}