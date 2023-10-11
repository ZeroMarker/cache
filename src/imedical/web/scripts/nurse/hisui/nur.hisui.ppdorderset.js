$(function() {
	hospComp = GenHospComp("Nur_IP_DHCCLSetExec",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;
		getLinkOrderData("","");  
		reloadData();	
	}  ///ѡ���¼�	
	
	initUI();
})

///��ʼ��ҳ��
function initUI(){
	getLinkOrderData("","");
	initTable();
	reloadData();
}
// ��ȡ����ҽ���б�
function getLinkOrderData(arcItmDR,arcItmName) {	
	//ҽ������
	$HUI.combogrid("#linkOrd", {
		panelWidth: 500,
		panelHeight: 330,
		delay:500,
		mode:'remote',
		idField: 'ArcimDR',
		textField: 'ArcimDesc',
		columns: [[
			{field:'ArcimDesc',title:'��Ŀ����',width:100},
			{field:'ArcimDR',title:'��ĿID',width:30}
		]],
		pagination : true,
		//url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=FindMasterItem&arcimdesc=",
		url:$URL+"?ClassName=Nur.NIS.Service.NursingGrade.DataConfig&QueryName=FindMasterItem&arcimdesc=",
		fitColumns: true,
		enterNullValueClear:true,
		multiple:true,
		onBeforeLoad:function(param){
			if(arcItmName){
				param['q']=arcItmName;
				arcItmName=""
			}
			if (param['q']) {
				var desc=param['q'];
			}
			param = $.extend(param,{arcimdesc:desc,HospId:$HUI.combogrid('#_HospList').getValue()});
		},
		onLoadSuccess:function(){
			if(arcItmDR){
	            $(this).combogrid('setValues', arcItmDR.split("^"));
	            arcItmDR="";     
	        }
		}
	});
}

// ��ʼ��������
function initTable(){
	$("#dg").datagrid({
		fit:true,
		columns :[[
	    	{field:'arcimDesc',title:'ҽ����',width:500}, 
	        {field:'oper',title:'����',align:"center",width:80,formatter:function(value,row,index){
		    	return '<a class="btnCls icon-cancel" href="#" onclick=deleteArcItms(\'' + row.arcimID + '\')></a>';
		    }}    	       
		]],
		singleSelect : true,
		rownumbers:true,
		loadMsg : '������..'
	})	
}
function reloadData(){
	$.m({
		ClassName:"web.DHCNurSkinTestList",
		MethodName:"GetPPDConfig",
		HospitalRowId:hospID
	},function(data){
		var data=eval(data);
		$("#dg").datagrid("loadData",data); 
	}) 
}

// ��������
function save(){
	var arcimIDs=$("#linkOrd").combogrid("getValues");
	if(arcimIDs.length==0){
	   return $.messager.popover({ msg: "ҽ�����Ϊ�գ�", type:'alert', style:{top:"100px",left:""}});		
	}
	var rows=$("#dg").datagrid("getRows");
	if(rows.length>0){
		var desc="";
		rows.forEach(function(val){
			var index=arcimIDs.indexOf(val.arcimID);
			if(index>-1){
				desc=desc=="" ? val.arcimDesc : desc+"��"+val.arcimDesc;
				arcimIDs.splice(index,1);	
			}	
		})
		if(desc!=""){
			return $.messager.alert("����ʾ", "ҽ���"+desc+"�Ѵ��ڣ������ظ���ӣ�", 'info');
		}
	}
	$.m({
		ClassName:"web.DHCNurSkinTestList",
		MethodName:"InsertPPDConfig",
		arcimID:arcimIDs.join("^"), 
		HospID:hospID
	},function testget(result){	
		if(result==0){
			$.messager.popover({ msg: "����ɹ���", type:'success' ,style:{top:"100px",left:""},timeout:3000});
			$("#linkOrd").combogrid("setValues",[]);
			getLinkOrderData("","");
			reloadData();	
		}else{
			$.messager.popover({ msg: result, type:'error' ,style:{top:"100px",left:""}});
		}		
	});
}
// ɾ��
function deleteArcItms(arcimID){
	$.messager.confirm("����ʾ", "ȷ��Ҫɾ������������", function (r) {
		if (r) {
			$.m({
				ClassName:"web.DHCNurSkinTestList",
				MethodName:"UpdatePPDConfig",
				ppdConfig:arcimID, 
				HospitalRowId:hospID
			},function testget(result){
				if(result == 0){
					$.messager.popover({msg:"ɾ���ɹ���", type:'success'});			
					reloadData();					
				}else{	
					$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });	
				}
			}); 			
		}
	});	
}