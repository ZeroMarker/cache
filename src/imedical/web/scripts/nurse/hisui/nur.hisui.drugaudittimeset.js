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
	}  ///选中事件	
	initUI();
})

///初始化页面
function initUI(){
	getLinkWardData();
	getPharmacyData();
	initTable();
	reloadDataGrid();
}
// 科室列表
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
// 初始化列表
function initTable(){
	var toolBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() { 
            	flag=0;
                ShowDrugAuditTimeSetWin(flag);
            }
        },{
	        text: '修改',
	        iconCls: 'icon-edit',
	        handler: function() {
		        var row=$("#dg").datagrid("getSelections");
			   	if(row.length==0){
				   return $.messager.popover({ msg: "请选择要修改的数据！", type:'error'});		
				}
	            flag=1;
	            setDrugAuditTimeSetData(row[0]);
                ShowDrugAuditTimeSetWin(flag);
	        }
	   },{
	        text: '删除',
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
	    	//{field:'Ward',title:'科室ID',width:100}, 
	    	{field:'WardDesc',title:'科室',width:300},
	    	{field:'pharmacy',title:'药房',width:150},
	    	{field:'SDate',title:'开始日期',width:100}, 
	    	{field:'STime',title:'开始时间',width:100}, 
	    	{field:'EDate',title:'截止日期',width:100}, 
	        {field:'ETime',title:'截止时间',width:100} 
		]],
		singleSelect : true,
		loadMsg : '加载中..',
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

// 保存设置
function saveTimeSet(){
   	var id="",wardID="",medTyp="",startDate="",startTime="",endDate="",endTime="",pharmacy="";
   	var row=$("#dg").datagrid("getSelections");
   	if(flag){ //修改
	   	if(row.length==0){
		   return $.messager.popover({ msg: "请选择要修改的数据！", type:'info'});		
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
		return $.messager.popover({ msg: "科室和药房不能同时为空！", type:'error'});
	}
	if(startDate=="" || startTime=="" || endDate=="" ||endTime==""){
		return $.messager.popover({ msg: "开始、截止时间不能为空！", type:'error'});
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
			$.messager.popover({ msg: "保存成功！", type:'success'});
			$('#drugAuditTimeSetWin').window("close");
			//reloadDataGrid();	
		}else{
			$.messager.popover({ msg: result, type:'error'});
		}		
	});
}
// 删除设置
function delTimeSet(){
   	var row=$("#dg").datagrid("getSelections");
   	if(row.length==0){
	   return $.messager.popover({ msg: "请选择要删除的数据！", type:'info'});		
	}
	$.m({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		MethodName:"DelTimeSet",
		id:row[0].id
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "删除成功！", type:'success'});
			reloadDataGrid();	
		}else{
			$.messager.popover({ msg: "删除失败！", type:'error'});
		}		
	});
}
function ShowDrugAuditTimeSetWin(flag){
	$('#drugAuditTimeSetWin').window({
		title: flag?'修改':'增加',
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