var PageLogicObj={
	m_RegDocAppointDataGrid:"",
};
$(document).ready(function(){ 
	 Init();
	 InitEvent();
	 RegDocAppointDataGridLoad();
});
function Init(){
	//��ʼ��ҽԺ
	var hospComp = GenHospComp("Doc_OPAdm_DocApp");
	hospComp.jdata.options.onSelect = function(e,t){
		var HospID=t.HOSPRowId;
		InitRegLoc();
		InitAppLoc();
		InitRegDoc("","");
		InitAppMark("","");
		$("#AppNum").val("");
		setTimeout(function() { 
        	RegDocAppointDataGridLoad();
        });
	}
	PageLogicObj.m_RegDocAppointDataGrid=InitRegDocAppointDataGrid();
	InitRegLoc();
	InitAppLoc();
};

function InitEvent(){
	$('#BFind').click(RegDocAppointDataGridLoad)	
	$('#BClear').click(function() {
		ClearData();
		RegDocAppointDataGridLoad();	
	})
	$(document.body).bind("keydown",BodykeydownHandler)
}

function InitRegDocAppointDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle();}
    },{
        text: '�޸�',
        iconCls: 'icon-update',
        handler: function() { UpdateClickHandle();}
    },{
        text: 'ɾ��',
        iconCls: 'icon-remove',
        handler: function() { DeleteClickHandle();}
    }];
	var LocColumns=[[ 
		{checkbox:true},
		{ field: 'RegLocDesc', title: '�������', width: 300, sortable: true},
		{ field: 'RegLocID', title: '�������ID', width: 10, sortable: true,hidden:true},
		{ field: 'RegDocDesc', title: '����ҽ��', width: 200, sortable: true},
		{ field: 'RegDocID', title: '����ҽ��ID', width: 10, sortable: true,hidden:true},
		{ field: 'AppLocDesc', title: 'ԤԼ����', width: 300, sortable: true},
		{ field: 'AppLocID', title: 'ԤԼ����ID', width: 10, sortable: true,hidden:true},
		{ field: 'AppMarkDesc', title: 'ԤԼ�ű�', width: 300, sortable: true},
		{ field: 'AppMarkID', title: 'ԤԼ�ű�ID', width: 10, sortable: true,hidden:true},
		{ field: 'AppNumber', title: 'ԤԼ����', width: 300, sortable: true},
		{ field: 'RowID', title: 'ID', width: 10, sortable: true,hidden:true}
	]];
	var RegDocAppointDataGrid=$('#DHCDocRegDocAppointTab').datagrid({  
		fit : true,
		//width : 1000,
		border : false,
		striped : true,
		//singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		loadMsg : '������..',  
		pagination : true,
		rownumbers : true,
		idField:"RowID",
		pageSize : 15,
		pageList : [15,50,100],
		columns :LocColumns,
		toolbar :toobar,
		onCheck:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_RegDocAppointDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_RegDocAppointDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_RegDocAppointDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		},
		onLoadSuccess:function(){
			$("#DHCDocRegDocAppointTab").datagrid('unselectAll');
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	return RegDocAppointDataGrid;	
}
function SetSelRowData(row){
	$HUI.combobox("#RegLoc").setValue(row["RegLocID"]);
	$HUI.combobox("#AppLoc").setValue(row["AppLocID"]);
	if(row["AppLocID"]!=""){
		InitAppMark(row["AppLocID"],row["AppMarkID"]);
	}
	if(row["RegLocID"]!=""){
		InitRegDoc(row["RegLocID"],row["RegDocID"]);
	}
	$("#AppNum").val(row["AppNumber"]);
}
function ClearData(){
	$HUI.combobox("#RegLoc").setValue("");	
	$HUI.combobox("#RegDoc").setValue("");	
	$HUI.combobox("#AppLoc").setValue("");
	$HUI.combobox("#AppMark").setValue("");
	InitAppMark("","");
	InitRegDoc("","");
	$("#AppNum").val("")
}

function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var RegLocID=$HUI.combobox("#RegLoc").getValue();
	var RegLocID=CheckComboxSelData("RegLoc",RegLocID)	
	var RegDocID=$HUI.combobox("#RegDoc").getValue();
	var RegDocID=CheckComboxSelData("RegDoc",RegDocID)	
	
	var AppLocID=$HUI.combobox("#AppLoc").getValue();
	var AppLocID=CheckComboxSelData("AppLoc",AppLocID)	
		
	var AppMarkID=$HUI.combobox("#AppMark").getValues();
	var AppMarkID=CheckComboxSelData("AppMark",AppMarkID)
	var AppNum=$("#AppNum").val()
	AppMarkID=AppMarkID.join("^");
	$.cm({
		ClassName:"web.DHCDocRegDocAppiont",
		MethodName:"SetUserCanDo",
		Loc:RegLocID, 
		RESRowIDStr:AppMarkID, 
		DocID:RegDocID, 
		AppNum:AppNum,
		dataType:"text",
	},function(rtn){
		if (rtn==0){
			$.messager.show({title:"��ʾ",msg:"�����ɹ�"});
			PageLogicObj.m_RegDocAppointDataGrid.datagrid('uncheckAll');
		}else{
			var msg="";
			if(rtn.indexOf("-101")>-1){
				msg=rtn.split("^")[1]+",����ʧ��!�ű�����ѡ������ά��";
				$.messager.alert("��ʾ",msg,"info");
			}
			else{
				msg=rtn
				$.messager.alert("��ʾ","����ʧ��!"+msg,"error");
			}
		}
		ClearData();
		RegDocAppointDataGridLoad();
	});	
}

function UpdateClickHandle(){
	var Rowid="";
	var row=PageLogicObj.m_RegDocAppointDataGrid.datagrid('getChecked');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ�޸ĵļ�¼!","info");
		return false;
	}
	if (row.length>1) {
		$.messager.alert("��ʾ","��ѡ��һ����¼!","info");
		return false;
	}
	Rowid=row[0].RowID;	
		
	if (!CheckDataValid()) return false;
	var RegLocID=$HUI.combobox("#RegLoc").getValue();
	var RegLocID=CheckComboxSelData("RegLoc",RegLocID)	
	var RegDocID=$HUI.combobox("#RegDoc").getValue();
	var RegDocID=CheckComboxSelData("RegDoc",RegDocID)	
	
	var AppLocID=$HUI.combobox("#AppLoc").getValue();
	var AppLocID=CheckComboxSelData("AppLoc",AppLocID)	
		
	var AppMarkID=$HUI.combobox("#AppMark").getValues();
	var AppMarkID=CheckComboxSelData("AppMark",AppMarkID);
	AppMarkID=trimSpace(AppMarkID)
	if(AppMarkID.length>1){
		$.messager.alert("��ʾ","�޸ļ�¼ԤԼ�ű�ֻ��ѡ��һ���ű�!","info");
		return false;	
	}
	AppMarkID=AppMarkID.join("^");
	var AppNum=$("#AppNum").val()
	$.cm({
		ClassName:"web.DHCDocRegDocAppiont",
		MethodName:"UpdateUserCanDo",
		RowID:Rowid, 
		Loc:RegLocID, 
		RESRowID:AppMarkID, 
		DocID:RegDocID,
		AppNum:AppNum,
		dataType:"text"
	},function(rtn){
		if (rtn==0){
			$.messager.show({title:"��ʾ",msg:"�޸ĳɹ�"});
			PageLogicObj.m_RegDocAppointDataGrid.datagrid('uncheckAll');
			ClearData();
			RegDocAppointDataGridLoad();
		}else{
			var msg="";
			if(rtn=="-101"){msg="�úű�����ѡ������ά��"}
			else if(rtn=="-103"){msg="����ҽ���Ѿ������˸úű�"}
			else{msg=rtn}
			$.messager.alert("��ʾ","�޸�ʧ��!"+msg,"error");
			return false;
		}
	});	
}
//ȥ�������еĿ�ֵ
function trimSpace(array){
	 for(var i = 0 ;i<array.length;i++)
	 {
         if(array[i] == "" || typeof(array[i]) == "undefined")
         {
                  array.splice(i,1);
                  i= i-1;
         }
	 }
	 return array;
}

function DeleteClickHandle(){
	var Rowid="";
	var row=PageLogicObj.m_RegDocAppointDataGrid.datagrid('getChecked');
	if ((!row)||(row.length==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ���ļ�¼!","info");
		return false;
	}
	var ret=0
	$.each(row, function(index, Data){
		Rowid=Data.RowID;	
		$.cm({
			ClassName:"web.DHCDocRegDocAppiont",
			MethodName:"DeleteUserCanDo",
			RowID:Rowid,
		},function(rtn){
			if (rtn==0){
				
			}else{
				ret=100
				$.messager.alert("��ʾ","ɾ��ʧ��!�������:"+rtn,"error");
				return false;
			}
		});	
	}) 
	if (ret==0) $.messager.show({title:"��ʾ",msg:"ɾ���ɹ�"});
	PageLogicObj.m_RegDocAppointDataGrid.datagrid('uncheckAll');
	ClearData();
	RegDocAppointDataGridLoad();
}

function CheckDataValid(){
	var RegLocID=$HUI.combobox("#RegLoc").getValue();
	var RegLocID=CheckComboxSelData("RegLoc",RegLocID)	
	if(RegLocID==""){
		$.messager.alert("��ʾ","��ѡ����Ч�ľ������","info");
		return false
	}
	
	var AppLocID=$HUI.combobox("#AppLoc").getValue();
	var AppLocID=CheckComboxSelData("AppLoc",AppLocID)	
	if(AppLocID==""){
		$.messager.alert("��ʾ","��ѡ����Ч��ԤԼ����","info");
		return false
	}
		
	var AppMarkID=$HUI.combobox("#AppMark").getValues();
	var AppMarkID=CheckComboxSelData("AppMark",AppMarkID)	
	if(AppMarkID==""){
		$.messager.alert("��ʾ","��ѡ����Ч��ԤԼ�ű�","info");
		return false
	}
	
	return true;
}

function RegDocAppointDataGridLoad()
{ 
	var RegLocID=$HUI.combobox("#RegLoc").getValue();
	var RegLocID=CheckComboxSelData("RegLoc",RegLocID);
	var RegDocID=$HUI.combobox("#RegDoc").getValue();
	var RegDocID=CheckComboxSelData("RegDoc",RegDocID)	
	var HospID=$HUI.combogrid('#_HospList').getValue();	
	$.cm({
		ClassName:"web.DHCDocRegDocAppiont",
		QueryName:"FindRegDocAppoint",
		'RegLocID':RegLocID,
		'RegDocID':RegDocID,
		'HospID':HospID,
		Pagerows:PageLogicObj.m_RegDocAppointDataGrid.datagrid("options").pageSize,
		rows:99999
	},function(GridData){
		PageLogicObj.m_RegDocAppointDataGrid.datagrid('uncheckAll').datagrid('loadData',GridData);
	})
	
};

function InitRegLoc(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
		ClassName:"web.DHCOPAdmReg",
		QueryName:"OPDeptList",
		'UserId':"",
		'AdmType':"O^E^I",
		'HospitalID':HospID,
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#RegLoc", {
			valueField: 'CTCode',
			textField: 'CTDesc', 
			editable:true,
			data: Data["rows"],
			filter: function(q, row){
				return ((row["CTDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
			},onSelect:function(record){
				InitRegDoc(record.CTCode,"");
				RegDocAppointDataGridLoad();
			}
		});
	});
}
function InitRegDoc(val,setval){
	//if((typeof(val)=='undefined')||(val==""))return;
	var HospID=$HUI.combogrid('#_HospList').getValue();	
	var ret=$.cm({
		ClassName:"web.DHCDocRegDocAppiont",
		MethodName:"GetRBResDr",
		'LocID':val,
		'DocFlag':"Y",
		"HospID":HospID,
		dataType:"text",
	},false)
	var EditTypeArr=new Array();
	var Dem="!";
	if(ret!=""){
		var retArr=ret.split("^")
		for(var i=0;i<retArr.length;i++){
			var value=retArr[i].split(Dem)[0];
			var desc=retArr[i].split(Dem)[1];
			var code=retArr[i].split(Dem)[2];
			var onestr = {"value":value, "desc":desc, "code":code};
			EditTypeArr.push(onestr);	
		}
	}
	$HUI.combobox("#RegDoc",{
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
    	multiple:false, 
    	//editable:false,
    	selectOnNavigation:false,
		filter: function(q, row){
			return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onSelect:function(record){
			var row=PageLogicObj.m_RegDocAppointDataGrid.datagrid('getChecked');
			if ((!row)||(row.length==0)){
				RegDocAppointDataGridLoad();
			}
		},onLoadSuccess:function(){
			$HUI.combobox("#RegDoc").setValue("");
			var setvalArr=new Array()
			setvalArr.push(setval);	
			var gsetval=CheckComboxSelData("RegDoc",setvalArr);
			if(gsetval!=""){
				$HUI.combobox("#RegDoc").setValue(gsetval);	
			}
		},filter: function(q, row){
			return ((row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["code"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
		}	
	})	
}
function InitAppLoc(){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	$.cm({
		ClassName:"web.DHCOPAdmReg",
		QueryName:"OPDeptList",
		'UserId':"",
		'AdmType':"O^E",
		'HospitalID':HospID,
		dataType:"json",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#AppLoc", {
				valueField: 'CTCode',
				textField: 'CTDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return ((row["CTDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CTAlias"].toUpperCase().indexOf(q.toUpperCase()) >= 0));
				},onSelect:function(record){
					InitAppMark(record.CTCode,"");
				}
		 });
	});
}
function InitAppMark(val,setval){
	//if((typeof(val)=='undefined')||(val==""))return;
	var HospID=$HUI.combogrid('#_HospList').getValue();	
	var ret=$.cm({
		ClassName:"web.DHCDocRegDocAppiont",
		MethodName:"GetRBResDr",
		'LocID':val,
		'HospID':HospID,
		dataType:"text",
	},false)
	var EditTypeArr=new Array();
	var Dem="!";
	if(ret!=""){
		var retArr=ret.split("^")
		for(var i=0;i<retArr.length;i++){
			var value=retArr[i].split(Dem)[0];
			var desc=retArr[i].split(Dem)[1];
			var onestr = {"value":value, "desc":desc};
			EditTypeArr.push(onestr);	
		}
	}
	$HUI.combobox("#AppMark",{
		valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
    	multiple:true, 
    	editable:false,
    	selectOnNavigation:false,
		filter: function(q, row){
			return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onLoadSuccess:function(){
			$HUI.combobox("#AppMark").setValue("");
			var setvalArr=new Array()
			setvalArr.push(setval);	
			var gsetval=CheckComboxSelData("AppMark",setvalArr);
			if(gsetval!=""){
				$HUI.combobox("#AppMark").setValue(gsetval);	
			}
		},formatter:function(row){  
			var opts;
			//if(row.selected==true){
			if(row.value==setval){
				opts = row.desc+"<span id='i"+row.value+"' class='icon icon-ok'></span>";
			}else{
				opts = row.desc+"<span id='i"+row.value+"' class='icon'></span>";
			}
			return opts;
		},
		onSelect:function(rec) {
			var obji =  document.getElementById("i"+rec.value);
			$(obji).addClass('icon-ok');
		},
		onUnselect:function(rec){
			var obji =  document.getElementById("i"+rec.value);
			$(obji).removeClass('icon-ok');
		}	
	})	
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //�������Backspace������  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        //e.preventDefault(); 
        return false;  
    }  
}
function CheckComboxSelData(id,selId){
	var Find=0;
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		if ((id=="AppLoc")||(id=="RegLoc")){
			var CombValue=Data[i].CTCode;
			var CombDesc=Data[i].CTDesc;
			if(selId==CombValue){
				selId=CombValue;
				Find=1;
				break;
			}
		}else if (id=="AppMark"){
			var CombValue=Data[i].value  
			var CombDesc=Data[i].desc
			if((','+selId.join(",")+",").indexOf(","+CombValue+",")>-1){
				//selId=CombValue;
				Find=1;
				break;
			}
		}else{
			var CombValue=Data[i].value  
			var CombDesc=Data[i].desc
			if(selId==CombValue){
				selId=CombValue;
				Find=1;
				break;
			}	
		}

	}
	if (Find=="1") return selId
	return "";
}