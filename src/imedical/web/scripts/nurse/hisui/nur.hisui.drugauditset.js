$(function() {
	hospComp = GenHospComp("Nur_IP_NurseSetNew",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	///var hospComp = GenHospComp("ARC_ItemCat")
	// console.log(hospComp.getValue());     //��ȡ�������ֵ
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		// 	HOSPDesc: "������׼�����ֻ�ҽԺ[��Ժ]"
		// HOSPRowId: "2"
		console.log(arguments);
		hospID=d.HOSPRowId;    	
       	editIndex=undefined,editIndex2=undefined,editIndex3=undefined,editIndex4=undefined;
       	saveFlag=false,saveFlag2=false,saveFlag3=false,saveFlag4=false;
       	reloadGridData("dg","durgauditnew","west","");
       	reloadGridData("dg2","durgauditnew","north","");
       	reloadGridData("dg3","durgauditnew","south","");
       	reloadGridData("dg4","durgauditnew","error","");
       	reloadGridData("","durgauditnew","period",0);
		reloadGridData("","durgauditnew","other",0);
		reloadGridData("","durgauditnew","other",1);
	}  ///ѡ���¼�	
	
	initUI();
	//������ѯ���á���������-���水ť�ڼ���ģʽ�£����水ť�����뱣��ͼ���λ��ʾ
	if (HISUIStyleCode=="lite"){
		$("#accPanel .icon-save,#accPanel2 .icon-save").css("padding-top","0");
		$("#accPanel .icon-save,#accPanel2 .icon-save").css("margin-left","0");
	}
})

// ��ʼ��ҳ��
function initUI(){
	// ��ѯ����
	initConditionTable();
	reloadGridData("dg","durgauditnew","west","");
	// ҩƷ��ѯ
	initDrugTable();
	reloadGridData("dg2","durgauditnew","north","");
	// ��ϸ��ѯ
	initDetailTable();
	reloadGridData("dg3","durgauditnew","south","");
	// ��˿���
	initAuditTable();
	reloadGridData("dg4","durgauditnew","error","");
	// ��ѯʱ��
	reloadGridData("","durgauditnew","period",0);
	// ��������
	reloadGridData("","durgauditnew","other",0);
	reloadGridData("","durgauditnew","other",1);
	loadAuthItemHtml();
}
// ��ʼ����ѯ����
function initConditionTable(){
	$('#dg').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'��ǩ',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'�ֶ�',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'ѡ��',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	        {field:'field4',title:'����',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'˳��',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
		            if(editIndex!=undefined){
			            // �б༭�У�����ʱ����༭�У�1�������µı༭��
						saveGridData("dg","durgauditnew","west","",1,editIndex);
					}else{
						addData("dg","durgauditnew","west","");	
					}					
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteData("dg","durgauditnew","west");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '����',
            	handler: function () {
                	saveGridData("dg","durgauditnew","west","","",editIndex);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex!=undefined)&&(editIndex!=rowIndex)&&!saveGridData("dg","durgauditnew","west","","",editIndex)) return;
			$('#dg').datagrid("endEdit",editIndex);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag) return;
			editIndex=rowIndex;
			$('#dg').datagrid("beginEdit", editIndex);			
		}
	});	
}
// ��ʼ��ҩƷ��ѯ
function initDrugTable(){
	$('#dg2').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'��ǩ',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'�ֶ�',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'���',width:90,editor:{type:'numberbox'}},
	        {field:'field4',title:'����',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'˳��',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
					if(editIndex2!=undefined){
			            // �б༭�У�����ʱ����༭�У�1�������µı༭��
						saveGridData("dg2","durgauditnew","north","",1,editIndex2);
					}else{
						addData("dg2","durgauditnew","north","");	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
	            	deleteData("dg2","durgauditnew","north");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '����',
            	handler: function () {
                	saveGridData("dg2","durgauditnew","north","","",editIndex2);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex2!=undefined)&&(editIndex2!=rowIndex)&&!saveGridData("dg2","durgauditnew","north","","",editIndex2)) return;
			$('#dg2').datagrid("endEdit",editIndex2);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag2) return;
			editIndex2=rowIndex;
			$('#dg2').datagrid("beginEdit", editIndex2);			
		}
	});	
}
// ��ʼ����ϸ��ѯ
function initDetailTable(){
	$('#dg3').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'��ǩ',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'�ֶ�',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'���',width:90,editor:{type:'numberbox'}},
	        {field:'field4',title:'����',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'˳��',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
					if(editIndex3!=undefined){
			            // �б༭�У�����ʱ����༭�У�1�������µı༭��
						saveGridData("dg3","durgauditnew","south","",1,editIndex3);
					}else{
						addData("dg3","durgauditnew","south","");	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteData("dg3","durgauditnew","south");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '����',
            	handler: function () {
                	saveGridData("dg3","durgauditnew","south","","",editIndex3);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex3!=undefined)&&(editIndex3!=rowIndex)&&!saveGridData("dg3","durgauditnew","south","","",editIndex3)) return;
			$('#dg3').datagrid("endEdit",editIndex3);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag3) return;
			editIndex3=rowIndex;
			$('#dg3').datagrid("beginEdit", editIndex3);			
		}
	});	
}
// ��ʼ����˿���
function initAuditTable(){
	$('#dg4').datagrid({
		columns :[[
			{field:'rowid',title:'ID',hidden:true,editor:{type:'text'}},
	    	{field:'field1',title:'��ǩ',width:100,editor:{type:'validatebox'}},  
	    	{field:'index3',title:'�ֶ�',width:120,editor:{type:'validatebox'}}, 
	    	{field:'field3',title:'��ɫ',width:90,editor:{type:'text'},styler: function(value,row,index){				
				return 'background-color:'+value;				
			}},
	        {field:'field4',title:'����',width:50,formatter:function(value,row,index){
		    	return value=="Y" ? "��" : "��";
		    },editor:{type:'icheckbox',options:{on:'Y',off:'N'}}},
	    	{field:'field2',title:'˳��',width:50,editor:{type:'numberbox'}}	    	       
		]],
		toolbar:[
			{
	            iconCls: 'icon-add',
	            text: '����',
	            handler: function () {
					if(editIndex4!=undefined){
			            // �б༭�У�����ʱ����༭�У�1�������µı༭��
						saveGridData("dg4","durgauditnew","error","",1,editIndex4);
					}else{
						addData("dg4","durgauditnew","error","");	
					}
	            }
			},{
            	iconCls: 'icon-cancel',
            	text: 'ɾ��',
            	handler: function () {
                	deleteData("dg4","durgauditnew","error");
            	}
         	},{
            	iconCls: 'icon-save',
            	text: '����',
            	handler: function () {
                	saveGridData("dg4","durgauditnew","error","","",editIndex4);
            	}
         	}
        ],
		singleSelect : true,
		loadMsg : '������..',
		onClickRow:function(rowIndex,rowData){
			if((editIndex4!=undefined)&&(editIndex4!=rowIndex)&&!saveGridData("dg4","durgauditnew","error","","",editIndex4)) return;
			$('#dg4').datagrid("endEdit",editIndex4);
		},
		onDblClickRow:function(rowIndex, rowData){
			if(saveFlag4) return;
			editIndex4=rowIndex;
			$('#dg4').datagrid("beginEdit", editIndex4);
			var ed = $('#dg4').datagrid('getEditor', {index:editIndex4,field:'field3'});
			$(ed.target).color({
				editable:true,
				width:90,
				height:30
			});			
		}
	});	
}
// ���ر�����
function reloadGridData(obj,index1,index2,index3,flag){
	$.cm({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		QueryName:"FindData",
		hospID:hospID,
		index1:index1,
		index2:index2,
		index3:index3,
		rows:99999
	},function(data){
		console.log(data);
		if(obj){
			$("#"+obj).datagrid('loadData',data);
			if(flag) addData(obj,index1,index2,index3);	
		}else{
			var record=data.rows;
			if(record.length>0){
				if(index2=="period"){
					// ��ѯʱ��		
					$("#rowid").val(record[0].rowid);	
					$("#start").numberbox('setValue',record[0].field3);
					$('#startTime').timespinner('setValue',record[0].field5); 
					$("#end").numberbox('setValue',record[0].field4);
					$('#endTime').timespinner('setValue',record[0].field6);		
				}else{
					// ��������	
					if(index3===0){
						$("#rowid2").val(record[0].rowid);
						if(record[0].field3=="Y"){
							$("#cb").checkbox("check");
						}else{
							$("#cb").checkbox("uncheck");
						}
						if(record[0].field4=="Y"){
							$("#cb6").checkbox("check");
						}else{
							$("#cb6").checkbox("uncheck");
						}	
						/*if(record[0].field5=="Y"){
							$("#cb7").checkbox("check");
						}else{
							$("#cb7").checkbox("uncheck");
						}
						if(record[0].field7=="Y"){
							$("#cb8").checkbox("check");
						}else{
							$("#cb8").checkbox("uncheck");
						}*/
						if(record[0].field8=="Y"){
							$("#cb9").switchbox("setValue",true);
							$("#cb11,#cb10").radio("enable");
						}else{
							$("#cb9").switchbox("setValue",false);
						}
						if(record[0].field9=="Y"){
							$("#cb10").radio("check");
						}else{
							$("#cb10").radio("uncheck");
						}
						if(record[0].field10=="Y"){
							$("#cb11").radio("check");
						}else{
							$("#cb11").radio("uncheck");
						}
						
						if(record[0].field11=="Y"){
							$("#cb12").radio("check");
						}else{
							$("#cb12").radio("uncheck");
						}
						if(record[0].field12=="Y"){
							$("#cb13").radio("check");
						}else{
							$("#cb13").radio("uncheck");
						}
						if(record[0].field13=="Y"){
							$("#cb14").radio("check");
						}else{
							$("#cb14").radio("uncheck");
						}
						if(record[0].field14=="Y"){
							$("#cb15").radio("check");
						}else{
							$("#cb15").radio("uncheck");
						}
						if(record[0].field15=="Y"){
							$("#cb16").checkbox("check");
						}else{
							$("#cb16").checkbox("uncheck");
						}
						
					}else{
						$("#rowid3").val(record[0].rowid);
						if(record[0].field3=="Y"){
							$("#cb2").checkbox("check");
						}else{
							$("#cb2").checkbox("uncheck");
						}
						if(record[0].field4=="Y"){
							$("#cb3").checkbox("check");
						}else{
							$("#cb3").checkbox("uncheck");
						}	
						if(record[0].field5=="Y"){
							$("#cb4").checkbox("check");
						}else{
							$("#cb4").checkbox("uncheck");
						}
						if(record[0].field6=="Y"){
							$("#cb5").checkbox("check");
						}else{
							$("#cb5").checkbox("uncheck");
						}
					}
				}
			}			
		}		
	})	
}

// �ж�����Ƿ��ظ�
function ifRepeat(records, repeatValue,curRowid) {
	var count = 0;
	for (var i = 0; i < records.length; i++) {
		if(records[i].rowid!=curRowid){
			if (repeatValue && repeatValue == records[i].field2) {
				count++;
				if (count > 0) {
					return true;
				}			
			}	
		}		
	}
	return false;	
}
// ��ѯ��������/����
var editIndex,editIndex2,editIndex3,editIndex4;
function addData(obj,index1,index2,index3){
	var index=$('#'+obj).datagrid('getRows').length;
	if(obj=="dg") editIndex=index;
	if(obj=="dg2") editIndex2=index;
	if(obj=="dg3") editIndex3=index;
	if(obj=="dg4") editIndex4=index;
	var row={
		rowid:"",
		index3:"",
		field1:"",
		field2:"",
		field3:"",
		field4:"",
		field5:"",
		field6:""
	};
	$('#'+obj).datagrid("insertRow", {row: row}).datagrid("beginEdit", index).datagrid("selectRow",index);
	var ed = $('#dg4').datagrid('getEditor', {index:index,field:'field3'});
	$(ed.target).color({
		editable:true,
		width:90,
		height:30
	});	
}
var saveFlag=false,saveFlag2=false,saveFlag3=false,saveFlag4=false;
// ����������
function saveGridData(obj,index1,index2,index3,flag,curEditIndex) {
	if (curEditIndex==undefined) {
		return $.messager.popover({msg: '����Ҫ��������ݣ�',type:'alert'});
	}
	var rowid="",field1="",field2="",field3="",field4="",field5="",field6="";
	var records=$("#"+obj).datagrid("getRows");
	var rowEditors=$('#'+obj).datagrid('getEditors',curEditIndex);	
	rowid=$(rowEditors[0].target).val();
	field1=$.trim($(rowEditors[1].target).val());
	index3=$.trim($(rowEditors[2].target).val());
	if(obj=="dg") field3=$(rowEditors[3].target).radio("getValue") ? "Y" : "";	
	if(obj=="dg2" || obj=="dg3") field3=$(rowEditors[3].target).numberbox("getValue");
	if(obj=="dg4") field3=$(rowEditors[3].target).color("getValue");
	field4=$(rowEditors[4].target).radio("getValue") ? "Y" : "";
	field2=$.trim($(rowEditors[5].target).numberbox("getValue"));
	var isInvalid=false;
	if (field1=="" || index3=="") {
		$.messager.popover({ msg: '��ǩ���ֶβ���Ϊ�գ�', type:'alert' });
		isInvalid=true;
	}
	if (ifRepeat(records,field2,rowid)) {
		$.messager.popover({ msg: '��˳����Ѵ��ڣ����ʵ��', type:'alert' });
		isInvalid=true;
	}
	if(!isInvalid){
		if(obj=="dg") saveFlag=false;
		if(obj=="dg2") saveFlag2=false;
		if(obj=="dg3") saveFlag3=false;
		if(obj=="dg4") saveFlag4=false;
	}else{
		if(obj=="dg") saveFlag=true;
		if(obj=="dg2") saveFlag2=true;
		if(obj=="dg3") saveFlag3=true;
		if(obj=="dg4") saveFlag4=true;
		return;
	}
	var parr=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6;
	$.m({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		MethodName:"SaveData",
		parr:parr,
		hospID:hospID,
		UserID:session['LOGON.USERID']
	},function testget(result){			
		if(result>0){
			$('#'+obj).datagrid("endEdit", curEditIndex);
			if(obj=="dg") editIndex=undefined;	
			if(obj=="dg2") editIndex2=undefined;	
			if(obj=="dg3") editIndex3=undefined;	
			if(obj=="dg4") editIndex4=undefined;	
			// flag�ж��Ƿ�����������ʱ���浱ǰ�༭�У��б����¼��غ�����µı༭��	
			reloadGridData(obj,index1,index2,"",flag);
			return true;	
		}else{	
			$.messager.popover({ msg: result, type:'error' });	
			return false;
		}
	});
}
// �����ѯʱ��/��������	
function saveTime(index1,index2){
	var rowid="",index3=0,field1="",field2="",field3="",field4="",field5="",field6="";
	rowid=$.trim($("#rowid").val());	
	field3=$.trim($("#start").numberbox("getValue"));
	field5=$.trim($('#startTime').timespinner('getValue'));  
	field4=$.trim($("#end").numberbox("getValue"));
	field6=$.trim($('#endTime').timespinner('getValue'));
	if(field3=="" || field4=="" || field5=="" || field6==""){
		return $.messager.popover({ msg: '��ѯʱ�䲻��Ϊ�գ�', type:'alert' });
	}
	var parr=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6;
	save(parr);
}
function saveOther(index1,index2){
	// ������ˡ���ҩ���ǰ�账����ܻ����ҽ���������¿�ҽ��������ܻ���ɺ��Զ���ҩ��ˡ��Ƿ���ʾδ����ҽ��
	var rowid="",index3=0,field1="",field2="",field3="",field4="",field5="",field6="",field7="";	
	rowid=$.trim($("#rowid2").val());
	field3=$("#cb").radio("getValue") ? "Y" : "";	
	field4=$("#cb6").radio("getValue") ? "Y" : ""; 
	field5=""; //$("#cb7").radio("getValue") ? "Y" : "";
	field7=""; //$("#cb8").radio("getValue") ? "Y" : "";
	field8=$("#cb9").switchbox("getValue") ? "Y" : "";
	field9=$("#cb10").radio("getValue") ? "Y" : "";
	field10=$("#cb11").radio("getValue") ? "Y" : "";
	
	field11=$("#cb12").radio("getValue") ? "Y" : "";
	field12=$("#cb13").radio("getValue") ? "Y" : "";
	field13=$("#cb14").radio("getValue") ? "Y" : "";
	field14=$("#cb15").radio("getValue") ? "Y" : "";
	field15=$("#cb16").checkbox("getValue") ? "Y" : "";
	var parr=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6+"^"+field7+"^"+field8+"^"+field9+"^"+field10+"^"+field11+"^"+field12+"^"+field13+"^"+field14+"^"+field15;
	save(parr);
	// �����ʾ�������ơ���������δ����ʾ����������δ������
	rowid=$.trim($("#rowid3").val());
	index3=1;
	field3=$("#cb2").radio("getValue") ? "Y" : "";	
	field4=$("#cb3").radio("getValue") ? "Y" : ""; 
	field5=$("#cb4").radio("getValue") ? "Y" : "";
	field6=$("#cb5").radio("getValue") ? "Y" : "";
	var parr2=rowid+"^"+index1+"^"+index2+"^"+index3+"^"+field1+"^"+field2+"^"+field3+"^"+field4+"^"+field5+"^"+field6+"^"+field7+"^"+field8+"^"+field9+"^"+field10+"^"+field11+"^"+field12+"^"+field13+"^"+field14+"^"+field15;
	save(parr2);
}
function save(parr){
	$.m({
		ClassName:"Nur.NIS.Service.DrugAudit.Setting",
		MethodName:"SaveData",
		parr:parr,
		hospID:hospID,
		UserID:session['LOGON.USERID']
	},function testget(result){			
		if(result>0){
			$.messager.popover({ msg: "����ɹ���", type:'success' });	
			loadAuthItemHtml();	
		}else{	
			$.messager.popover({ msg: "����ʧ��", type:'error' });	
		}
	});	
}
// ɾ����������
function deleteData(obj,index1,index2){	
	var rows=$("#"+obj).datagrid("getSelections");
	if(rows.length>0){
    	$.messager.confirm("����ʾ", "ȷ��Ҫɾ��������������", function (r) {
			if (r) {
				$.m({
					ClassName:"Nur.NIS.Service.DrugAudit.Setting",
					MethodName:"DeleteData",
					rw:rows[0].rowid
				},function testget(result){			
					if(result>0){
						$.messager.popover({ msg: "ɾ���ɹ���", type:'success' });
						reloadGridData(obj,index1,index2,"");		
					}else{	
						$.messager.popover({ msg: "ɾ��ʧ�ܣ�", type:'error' });	
					}
				});
			}
		});
    }else{
        $.messager.popover({ msg: "��ѡ��Ҫɾ�����������ݣ�", type:'info' });	
    }		
}
function stockControlCheck(){
	$("#cb2").checkbox("check");
}
function stockAlertUnCheck(){
	$("#cb3").checkbox("uncheck");
}
function inTheWayControlCheck(){
	$("#cb4").checkbox("check");
}
function inTheWayAlertUnCheck(){
	$("#cb5").checkbox("uncheck");
}
function switchChangeHandle(e,obj){
	if (obj.value){
		$("#cb11,#cb10").radio("enable");
	}else{
		$("#cb11,#cb10").radio("uncheck").radio("disable");
	}
}
function loadAuthItemHtml(){
    $cm({ClassName:"Nur.NIS.Service.DrugAudit.Setting",MethodName:"getAuthItem"},function(dataArr){
	    for (var i=0;i<dataArr.length;i++){
		    var rtn=$m({
		        ClassName: "BSP.SYS.SRV.AuthItemApply",
		        MethodName: 'GetStatusHtml',
		        AuthCode:dataArr[i].authCode
		    }, false);
		    if (rtn!=""){
			    $(".icon-stamp").remove();
				$(rtn).insertAfter('#'+dataArr[i].itemId+' + label');
			}
		}
	})
}