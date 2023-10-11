$(function() {
	hospComp = GenHospComp("Nur_IP_ImedicalStaffOfBed",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		getLinkWardData("","");  	
		reloadDataGrid();
	}  ///ѡ���¼�	
	
	initUI();
})

///��ʼ��ҳ��
function initUI(){
	getLinkWardData("","");
	getLinkDocData("","");
	getLinkNurseData();
	initTable();
}
// �����б�
function getLinkWardData(wardId,wardDesc){
	$HUI.combogrid("#linkWard", {
		panelWidth: 500,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'wardid',
		textField: 'warddesc',
		columns: [[
			{field:'warddesc',title:'����',width:100},
			{field:'wardid',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardNew",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(wardDesc){
				param['q']=wardDesc;
				wardDesc=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{desc:desc,hospid:$HUI.combogrid('#_HospList').getValue(),bizTable:"Nur_IP_ImedicalStaffOfBed"});
		},
		onLoadSuccess:function(){
			if(wardId){
				$(this).combogrid("setValue",wardId);	
				wardId="";
			}	
		},
		onSelect:function(record){
			getLinkDocData();
			getLinkNurseData();
			reloadDataGrid();
		}
	});	
}
//ֵ��ҽ���б�
function getLinkDocData(id,name){
	$HUI.combogrid("#linkDoctor", {
		panelWidth: 300,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'rowid',
		textField: 'doctorname',
		columns: [[
			{field:'doctorname',title:'����',width:100},
			{field:'rowid',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWarddoctor",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(name){
				param['q']=wardDesc;
				name=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{docName:desc,wardid:$HUI.combogrid('#linkWard').getValue()});
		},
		onLoadSuccess:function(){
			if(id){
				$(this).combogrid("setValue",id);	
				id="";
			}	
		}
	});	
}
//ֵ�໤ʿ�б�
function getLinkNurseData(id,name){
	$HUI.combogrid("#linkNurse", {
		panelWidth: 300,
		panelHeight: 350,
		delay:500,
		mode:'remote',
		idField: 'rowid',
		textField: 'nursename',
		columns: [[
			{field:'nursename',title:'����',width:100},
			{field:'rowid',title:'ID',width:50}
		]],
		pagination : true,
		url:$URL+"?ClassName=Nur.NIS.Service.Base.Ward&QueryName=GetallWardnurse",
		fitColumns: true,
		enterNullValueClear:true,
		onBeforeLoad:function(param){
			if(name){
				param['q']=wardDesc;
				name=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{nurName:desc,wardid:$HUI.combogrid('#linkWard').getValue()});
		},
		onLoadSuccess:function(){
			if(id){
				$(this).combogrid("setValue",id);	
				id="";
			}	
		}
	});	
}

// ��ʼ���б�
function initTable(){
	$("#dg").datagrid({
		fit:true,
		columns :[[
			{field:'ck',title:'ck',checkbox:true},  
	    	{field:'��λ',title:'��λ',width:100},  
	    	{field:'��λID',title:'��λID',width:100}, 
	    	{field:'ֵ��ҽ��',title:'ֵ��ҽ��',width:300},
	    	{field:'ֵ�໤ʿ',title:'ֵ�໤ʿ',width:300}	       
		]],
		loadMsg : '������..'	
	});
}
function reloadDataGrid(){
	$("#dg").datagrid("uncheckAll");
	$.cm({
		ClassName:"Nur.NIS.Service.Base.Ward",
		QueryName:"GetallWardbed",
		wardid:$HUI.combogrid('#linkWard').getValue(), 
		rows:99999
	},function(data){
		console.log(data);
		$("#dg").datagrid('loadData',data); 
	}) 
}

// ��������
function save(flag){
	var rows=$("#dg").datagrid("getSelections");
	if(rows.length==0){
	   return $.messager.popover({ msg: "��ѡ��Ҫά���Ĵ�λ��", type:'info', style:{top:"100px",left:""}});		
	}
	var bedArr=[];
	var docId=$("#linkDoctor").combogrid("getValue");
	var nurseId=$("#linkNurse").combogrid("getValue");
	rows.forEach(function(val){
		var arr=[];
		arr.push(val["��λID"]);
		arr.push(docId);
		arr.push(nurseId);
		bedArr.push(arr);	
	})
	$.m({
		ClassName:"Nur.NIS.Service.Base.Bed",
		MethodName:"UdateStaffOfBed",
		wardID:rows[0].wardid, 
		rowData:JSON.stringify(bedArr),
		ifUpdateNurse: flag ? flag : ""
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "����ɹ���", type:'success' ,style:{top:"100px",left:""}});
			$("#linkDoctor,#linkNurse").combogrid("setValue","");
			getLinkDocData("","");
			getLinkNurseData();
			reloadDataGrid();	
		}else{
			$.messager.popover({ msg: result, type:'error' ,style:{top:"100px",left:""}});
		}		
	});
}