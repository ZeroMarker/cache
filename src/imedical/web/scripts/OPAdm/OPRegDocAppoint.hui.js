var PageLogicObj={
	m_RegDocAppointDataGrid:"",
	m_RFRegLocListTabDataGrid:"",
	m_RFRegDocListTabDataGrid:"",
	m_RFAppLocListTabDataGrid:"",
	m_RFAppMarkListTabDataGrid:"",
	m_AFRegLocListTabDataGrid:"",
	m_AFRegDocListTabDataGrid:"",
	m_AFAppLocListTabDataGrid:"",
	m_AFAppMarkListTabDataGrid:"",
	m_AFRegDocInitLocId:"",
	m_AFRegDocInitLocFlag:0,
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
		$("#AppNum").numberbox('setValue',"");;
		setTimeout(function() { 
        	RegDocAppointDataGridLoad();
        });
	}
	PageLogicObj.m_RegDocAppointDataGrid=InitRegDocAppointDataGrid();
	InitRegLoc();
	InitAppLoc();
	$('#tab').tabs({    
	    onSelect:function(title,index){
		    SwitchTab();
	    }    
	});
	
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
    },{
		text:'����ά��',
		iconCls: 'icon-add',
		handler: function() {
			InitMulDocRegDocAppointWin();
		}
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
		{ field: 'AppNumber', title: 'ԤԼ����', width: 300, sortable: false},
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
		remoteSort: false,
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
	$("#AppNum").numberbox('setValue',row["AppNumber"]);
}
function ClearData(){
	$HUI.combobox("#RegLoc").setValue("");	
	$HUI.combobox("#RegDoc").setValue("");	
	$HUI.combobox("#AppLoc").setValue("");
	$HUI.combobox("#AppMark").setValue("");
	InitAppMark("","");
	InitRegDoc("","");
	$("#AppNum").numberbox('setValue',"")
	
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
	var AppNum=$("#AppNum").numberbox('getValue')
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
	var AppNum=$("#AppNum").numberbox('getValue')
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
	var AppLocID=$HUI.combobox("#AppLoc").getValue();
	var AppLocID=CheckComboxSelData("AppLoc",AppLocID);
	var AppMarkID=$HUI.combobox("#AppMark").getValues();
	var AppMarkID=CheckComboxSelData("AppMark",AppMarkID);
	if (AppMarkID!='') AppMarkID=AppMarkID.join('^');
	$.cm({
		ClassName:"web.DHCDocRegDocAppiont",
		QueryName:"FindRegDocAppoint",
		'RegLocID':RegLocID,
		'RegDocID':RegDocID,
		'HospID':HospID,
		'AppLocID':AppLocID,
		'AppMarkID':AppMarkID,
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
		console.log(1)
		console.log(Data["rows"].length)
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
		console.log(2)
		console.log(Data["rows"].length)
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

/**����������**/
///��ȡ��ǰ��������ģʽ:["RF":"RegFirst-���������","AF":"AppFirst-��ԤԼ����"]
function GetMulModifyMode(){
	var seltab=$('#tab').tabs('getSelected'); 
	var index = $('#tab').tabs('getTabIndex',seltab);
	return index==0?"RF":"AF";
}

///��ʼ������������
function InitMulDocRegDocAppointWin(){
	$('#MulDocRegDocAppointWin').window('open');
	ClaerMulWinInput();
	$('#tab').tabs('select',0);	
	SwitchTab();
}
function ClaerMulWinInput(){
	$("#RFFindRegLoc,#RFFindRegDoc,#RFFindAppLoc,#RFFindAppMark,#AFFindAppLoc,#AFFindAppMark,#AFFindRegLoc,#AFFindRegDoc").searchbox('setValue',"");
}


function SwitchTab(){
	if(GetMulModifyMode()=="AF"){
		InitAFAppLocListTabDataGrid();
		InitAFAppMarkListTabDataGrid();
		InitAFRegLocListTabDataGrid();
		InitAFRegDocListTabDataGrid();
	}else{
		InitRFRegLocListTabDataGrid();
		InitRFAppLocListTabDataGrid();
		InitRFRegDocListTabDataGrid();
		InitRFAppMarkListTabDataGrid();
	}
}

///input ��Ӧ�¼�
function RowInputOnChange(type,index){
	var InputVal=$("#"+type+"_"+index).val();
	var DGFunction=InputVal==""?"unSelectRow":"selectRow";
	
	if(type=="RFAppMark") PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid(DGFunction,index);
	return;
}

function ShowRDAPPNumStr(thatDom){
	if(!thatDom.id)return;
	var RowObj="";
	var DomIdArr=thatDom.id.split("_");
	var DomId=DomIdArr[1];
	var DomType=DomIdArr[0];
	
	if(DomType=="RFAppMark"){
		var DGRows=PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid('getRows');
		var DomIndex=PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid('getRowIndex',DomId);
		RowObj=DGRows[DomIndex];
	}
	if(DomType=="AFRegLoc"){
		var DGRows=PageLogicObj.m_AFRegLocListTabDataGrid.datagrid('getRows');
		var DomIndex=PageLogicObj.m_AFRegLocListTabDataGrid.datagrid('getRowIndex',DomId);
		RowObj=DGRows[DomIndex];
	}
	if(DomType=="AFRegDoc"){
		var DGRows=PageLogicObj.m_AFRegDocListTabDataGrid.datagrid('getRows');
		var DomIndex=PageLogicObj.m_AFRegDocListTabDataGrid.datagrid('getRowIndex',DomId);
		RowObj=DGRows[DomIndex];
	}
	
	if(!RowObj) return;
	
	var content=RowObj['RDAPPNumStr']
	if(!content) return;
	
	var MaxHeight=20;
	var len=content.split("<br/>").length;
	if (len>5) MaxHeight=150,placement="right";
	else MaxHeight='auto',placement="top";
	$(thatDom).webuiPopover({
		title:'ԤԼ����',
		content:content,
		trigger:'hover',
		placement:placement,
		style:'inverse',
		height:MaxHeight
		
	});
	$(thatDom).webuiPopover('show');
}


/*RF ���������*/
function InitRFRegLocListTabDataGrid(){
	if(PageLogicObj.m_RFRegLocListTabDataGrid!=""){
		PageLogicObj.m_RFRegLocListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;	
	}
	var Columns=[[ 
		{checkbox:true},
		{field:'CTDesc',title:'����',width:180},
		{field:'CTCode',title:'ID',width:50}
    ]]
	PageLogicObj.m_RFRegLocListTabDataGrid=$("#RFRegLocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,   
		idField:'CTCode',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=FindRDAPPLoc&UserId=&AdmType=O^E^I&HospitalID=&Desc=&AppMarks&rows=99999",
		onBeforeLoad:function(param){
			$("#RFRegLocListTab").datagrid("uncheckAll");
			var desc=$("#RFFindRegLoc").searchbox('getValue'); 
			param = $.extend(param,{Desc:desc,HospitalID:$HUI.combogrid('#_HospList').getValue()});
		},
		onCheck:function(){
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFRegDocListTabDataGrid();
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		},
		onUncheck:function(){
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFRegDocListTabDataGrid();
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		},
		onCheckAll:function(){
			if(PageLogicObj.m_RFRegDocListTabDataGrid=="") return;
			PageLogicObj.m_RFRegDocListTabDataGrid.datagrid("clearChecked");
			InitRFRegDocListTabDataGrid();
			if(PageLogicObj.m_RFAppMarkListTabDataGrid=="") return;
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		},
		onUncheckAll:function(){
			if(PageLogicObj.m_RFRegDocListTabDataGrid=="") return;
			PageLogicObj.m_RFRegDocListTabDataGrid.datagrid("clearChecked");
			InitRFRegDocListTabDataGrid();
			if(PageLogicObj.m_RFAppMarkListTabDataGrid=="") return;
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		},
		onLoadSuccess:function(data){
			
			console.log(3)
			console.log(data)
		}
	});
	return;
}

///��ʼ������ҽ���б�
function InitRFRegDocListTabDataGrid(){
	if (PageLogicObj.m_RFRegDocListTabDataGrid!="") {
		PageLogicObj.m_RFRegDocListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;
	}
	var Columns=[[ 
		{checkbox:true},
		{field:'DocDesc',title:'ҽ��',width:180},
		{field:'LocDesc',title:'����',width:80},
		{field:'DocId',title:'ID',width:50,hidden:true},
		{field:'LocId',title:'LocId',hidden:true},
    ]]
	PageLogicObj.m_RFRegDocListTabDataGrid=$("#RFRegDocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 100,
		pageList : [50,100,999],
		idField:'DocId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=RBResDrList&LocIDs=&QryDesc=&DocFlag=Y&ExpStr=&HospID=",
		onBeforeLoad:function(param){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			$("#RFRegDocListTab").datagrid("uncheckAll");
			var desc=$("#RFFindRegDoc").searchbox('getValue'); 
			var RegLocSelrow=PageLogicObj.m_RFRegLocListTabDataGrid.datagrid("getChecked");
			//var LocId=RegLocSelrow.length==1?RegLocSelrow[0].CTCode:"";
			var LocIDArr=[];
			for(var i=0;i<RegLocSelrow.length;i++){
				LocIDArr.push(RegLocSelrow[i].CTCode)
			}
			var LocIDs=LocIDArr.join("^")
			
			param = $.extend(param,{LocIDs:LocIDs,QryDesc:desc,HospID:HospID});
		},
		onCheck:function(){
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		},
		onUncheck:function(rows){
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		},
		onCheckAll:function(){
			if(PageLogicObj.m_RFAppMarkListTabDataGrid=="") return;
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		},
		onUncheckAll:function(){
			if(PageLogicObj.m_RFAppMarkListTabDataGrid=="") return;
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked");
			InitRFAppMarkListTabDataGrid();
		}
	});
	return;
} 
///��ʼ��ԤԼ�����б�
function InitRFAppLocListTabDataGrid(){
	if(PageLogicObj.m_RFAppLocListTabDataGrid!=""){
		PageLogicObj.m_RFAppLocListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;	
	}
	
	var Columns=[[ 
		{checkbox:true},
		{field:'CTDesc',title:'����',width:180},
		{field:'CTCode',title:'ID',width:50}
    ]]
	PageLogicObj.m_RFAppLocListTabDataGrid=$("#RFAppLocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'CTCode',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=FindRDAPPLoc&UserId=&AdmType=O^E&HospitalID=&Desc=&AppMarks=&rows=99999",
		onBeforeLoad:function(param){
			$("#RFAppLocListTab").datagrid("uncheckAll");
			var desc=$("#RFFindAppLoc").searchbox('getValue'); 
			param = $.extend(param,{Desc:desc,HospitalID:$HUI.combogrid('#_HospList').getValue()});
		},
		onCheck:function(){
			InitRFAppMarkListTabDataGrid();
		},
		onUncheck:function(rows){
			InitRFAppMarkListTabDataGrid();
		},
		onCheckAll:function(){
			if(PageLogicObj.m_RFAppMarkListTabDataGrid=="") return;
			InitRFAppMarkListTabDataGrid();
		},
		onUncheckAll:function(){
			if(PageLogicObj.m_RFAppMarkListTabDataGrid=="") return;
			InitRFAppMarkListTabDataGrid();
		},
	});
	return;
}
function InitRFAppMarkListTabDataGrid(){
	if (PageLogicObj.m_RFAppMarkListTabDataGrid!="") {
		PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;
	}
	var Columns=[[ 
		{checkbox:true},
		{field:'DocDesc',title:'�ű�',width:180,
			formatter:function(val,row){
				return '<a id= "RFAppMark_' + row["DocId"] + '"onmouseover="ShowRDAPPNumStr(this)">'+val+'</a>';
			}
		},	
		{field:'DocId',title:'ID',width:80,hidden:true},
		{field:'ChooseFlag',title:'ChooseFlag',hidden:true},
		{field:'RDAPPNumStr',title:'ԤԼ����˵��',width:200,showTip:true,tipWidth:200,hidden:true},
		{field:'RDAPPNum',title:'ԤԼ����',width:80,editor:{type:'numberbox',precision:0}},
		{field:'LocId',title:'LocId',hidden:true},
		{field:'LocDesc',title:'����',width:80},
    ]]
	PageLogicObj.m_RFAppMarkListTabDataGrid=$("#RFAppMarkListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,
		pageSize: 100,
		pageList : [50,100,999], 
		idField:'DocId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=RBResDrList&LocIDs=&QryDesc=&DocFlag=&ExpStr=&HospID=",
		onBeforeLoad:function(param){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			var desc=$("#RFFindAppMark").searchbox('getValue'); 
			var selrow=PageLogicObj.m_RFAppLocListTabDataGrid.datagrid("getChecked")
			var LocIDArr=[];
			for(var i=0;i<selrow.length;i++){
				LocIDArr.push(selrow[i]['CTCode']);
			}
			var LocIDs=LocIDArr.join("^");
			
			var ExtStr=""
			//�������ȼ����ű�ʱ���������Һ;���ҽ��,�����ж��Ƿ�ѡ�кű�
			if(typeof PageLogicObj.m_RFRegLocListTabDataGrid.datagrid =="function"){
				var RegLocSelrow=PageLogicObj.m_RFRegLocListTabDataGrid.datagrid("getChecked");
				var RegLocIds="",RegDocIds=""
				if(RegLocSelrow.length==1){
					//�����ҵ�ѡ,��ҽ����Ϊ��ѡ
					RegLocIds=RegLocSelrow[0].CTCode
					var RegDocSelrow=PageLogicObj.m_RFRegDocListTabDataGrid.datagrid("getChecked");
					var RegDocIds="";
					for(var i=0;i<RegDocSelrow.length;i++){
						RegDocIds=RegDocIds==""?RegDocSelrow[i].DocId:RegDocIds+"$"+RegDocSelrow[i].DocId;
					}
					
				}else if(RegLocSelrow.length>1){
					//�����Ҷ�ѡ,��ҽ��Ϊ��
					for(var i=0;i<RegLocSelrow.length;i++){
						RegLocIds=RegLocIds==""?RegLocSelrow[i].CTCode:RegLocIds+"$"+RegLocSelrow[i].CTCode;
					}
				}
				
				ExtStr=(RegLocIds!=""||RegDocIds!="")?"RF^"+RegLocIds+"^"+RegDocIds:"";
			}
			param = $.extend(param,{LocIDs:LocIDs,QryDesc:desc,HospID:HospID,ExtStr:ExtStr});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var ChooseFlag=data.rows[i].ChooseFlag;
				if (ChooseFlag=="Y") {
					PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid('selectRow',i);
				}
			}
		},
		onCheck:function(index,rows){
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid('beginEdit', index);
		},
		onUncheck:function(index,rows){
			//rows['RDAPPNum']="";
			//PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid('updateRow',{index:index,row:rows}).datagrid('endEdit', index);
			PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid('endEdit', index);
		}
	});
	return;
}


function RFFindRegLocChange(){
	PageLogicObj.m_RFRegLocListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}
function RFFindRegDocChange(){
	PageLogicObj.m_RFRegDocListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}
function RFFindAppLocChange(){
	PageLogicObj.m_RFAppLocListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}
function RFFindAppMarkChange(){
	PageLogicObj.m_RFAppMarkListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}

/*AF ��ԤԼ����*/
///��ʼ��ԤԼ�����б�
function InitAFAppLocListTabDataGrid(){
	if(PageLogicObj.m_AFAppLocListTabDataGrid!=""){
		PageLogicObj.m_AFAppLocListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;	
	}
	
	var Columns=[[ 
		{checkbox:true},
		{field:'CTDesc',title:'����',width:180},
		{field:'CTCode',title:'ID',width:50}
    ]]
	PageLogicObj.m_AFAppLocListTabDataGrid=$("#AFAppLocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'CTCode',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=FindRDAPPLoc&UserId=&AdmType=O^E&HospitalID=&Desc=&AppMarks=&rows=99999",
		onBeforeLoad:function(param){
			$("#AFAppLocListTab").datagrid("uncheckAll");
			var desc=$("#AFFindAppLoc").searchbox('getValue'); 
			param = $.extend(param,{Desc:desc,HospitalID:$HUI.combogrid('#_HospList').getValue()});
		},
		onCheck:function(){
			InitAFAppMarkListTabDataGrid();
		},
		onUncheck:function(){
			InitAFAppMarkListTabDataGrid();
		},
		onCheckAll:function(){
			if(PageLogicObj.m_AFAppMarkListTabDataGrid=="") return;
			InitAFAppMarkListTabDataGrid();
		},
		onUncheckAll:function(){
			if(PageLogicObj.m_AFAppMarkListTabDataGrid=="") return;
			InitAFAppMarkListTabDataGrid();
		}
	});
	return;
}

function InitAFAppMarkListTabDataGrid(){
	if (PageLogicObj.m_AFAppMarkListTabDataGrid!="") {
		PageLogicObj.m_AFAppMarkListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;
	}
	var Columns=[[ 
		{checkbox:true},
		{field:'LocDesc',title:'����',width:80},
		{field:'DocDesc',title:'�ű�',width:180},	
		{field:'DocId',title:'ID',width:50,hidden:true},
		{field:'LocId',title:'LocId',hidden:true},	
    ]]
	PageLogicObj.m_AFAppMarkListTabDataGrid=$("#AFAppMarkListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,
		pageSize: 100,
		pageList : [50,100,999], 
		idField:'DocId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=RBResDrList&LocIDs=&QryDesc=&DocFlag=&ExpStr=&HospID=",
		onBeforeLoad:function(param){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			$("#AFAppMarkListTab").datagrid("uncheckAll");
			var desc=$("#AFFindAppMark").searchbox('getValue'); 
			var selrow=PageLogicObj.m_AFAppLocListTabDataGrid.datagrid("getChecked")
			var LocIDArr=[];
			for(var i=0;i<selrow.length;i++){
				LocIDArr.push(selrow[i]['CTCode']);
			}
			var LocIDs=LocIDArr.join("^");
			param = $.extend(param,{LocIDs:LocIDs,QryDesc:desc,HospID:HospID});
		},
		onCheck:function(){
			if(PageLogicObj.m_AFRegLocListTabDataGrid=="")return;
			//PageLogicObj.m_AFRegLocListTabDataGrid.datagrid("clearChecked")
			//console.log("AFAppMark:check")
			InitAFRegLocListTabDataGrid();
		},
		onUncheck:function(){
			if(PageLogicObj.m_AFRegLocListTabDataGrid=="")return;
			//PageLogicObj.m_AFRegLocListTabDataGrid.datagrid("clearChecked")
			//console.log("AFAppMark:uncheck")
			InitAFRegLocListTabDataGrid();
		},
		onCheckAll:function(){
			if(PageLogicObj.m_AFRegLocListTabDataGrid=="")return;
			//PageLogicObj.m_AFRegLocListTabDataGrid.datagrid("clearChecked")
			console.log("AFAppMark:checkall")
			InitAFRegLocListTabDataGrid();
		},
		onUncheckAll:function(){
			if(PageLogicObj.m_AFRegLocListTabDataGrid=="")return;
			//console.log("AFAppMark:uncheckall")
			InitAFRegLocListTabDataGrid();
		}
	});
	return;
}


function InitAFRegLocListTabDataGrid(){
	if(PageLogicObj.m_AFRegLocListTabDataGrid!=""){
		PageLogicObj.m_AFRegLocListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;	
	}
	var Columns=[[ 
		{checkbox:true},
		{field:'CTDesc',title:'����',width:180,
			formatter:function(val,row){
				return '<a id= "AFRegLoc_' + row["CTCode"] + '"onmouseover="ShowRDAPPNumStr(this)">'+val+'</a>';
			}
		},
		{field:'CTCode',title:'ID',width:50,hidden:true},
		{field:'ChooseFlag',title:'ChooseFlag',hidden:true},
		{field:'RDAPPNum',title:'ԤԼ����',width:80,editor:{type:'numberbox',precision:0}},	
    ]]
	PageLogicObj.m_AFRegLocListTabDataGrid=$("#AFRegLocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : false,  
		rownumbers : false,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'CTCode',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=FindRDAPPLoc&UserId=&AdmType=O^E^I&HospitalID=&Desc=&AppMarks=&rows=99999",
		loadedFlag:0,
		onBeforeLoad:function(param){
			$("#AFRegLocListTab").datagrid("uncheckAll");
			var desc=$("#AFFindRegLoc").searchbox('getValue');
			var AppMarks=""
			if(PageLogicObj.m_AFAppMarkListTabDataGrid!=""){
				var AppMarkSelecter=PageLogicObj.m_AFAppMarkListTabDataGrid.datagrid("getChecked");
				for(var i=0;i<AppMarkSelecter.length;i++){
					AppMarks=AppMarks==""?AppMarkSelecter[i].DocId:AppMarks+"$"+AppMarkSelecter[i].DocId;
				}
			}
			param = $.extend(param,{Desc:desc,AppMarks:AppMarks,HospitalID:$HUI.combogrid('#_HospList').getValue()});
		},
	 	onCheck:function(index,rows){
			PageLogicObj.m_AFRegLocListTabDataGrid.datagrid('beginEdit', index);
		 	if(this.loadedFlag==0) return;
		 	//console.log("AFRegLoc:check"+"-"+index)
			InitAFRegDocListTabDataGrid();
		},
		onUncheck:function(index,rows){
			//rows['RDAPPNum']="";
			PageLogicObj.m_AFRegLocListTabDataGrid.datagrid('endEdit', index);
			if(this.loadedFlag==0) return;
			//console.log("AFRegLoc:uncheck"+"-"+index)
			InitAFRegDocListTabDataGrid();
		},
	 	onCheckAll:function(){
		 	if(this.loadedFlag==0) return;
		 	if(PageLogicObj.m_AFRegDocListTabDataGrid=="")return;
		 	//console.log("AFRegLoc:checkall")
			InitAFRegDocListTabDataGrid();
		},
		onUncheckAll:function(){
			if(this.loadedFlag==0) return;
			if(PageLogicObj.m_AFRegDocListTabDataGrid=="")return;
			//console.log("AFRegLoc:uncheckall")
			InitAFRegDocListTabDataGrid();
		}, 
		onLoadSuccess:function(data){
			this.loadedFlag=0;
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].ChooseFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_AFRegLocListTabDataGrid.datagrid('selectRow',i);
				}
			}
			//console.log("AFRegLoc:LoadSuccess")
			InitAFRegDocListTabDataGrid();
			this.loadedFlag=1;
		},
		
	});
	return;
}


///��ʼ������ҽ���б�
function InitAFRegDocListTabDataGrid(){
	if (PageLogicObj.m_AFRegDocListTabDataGrid!="") {
		PageLogicObj.m_AFRegDocListTabDataGrid.datagrid("load",{}).datagrid("reload");
		return;
	}
	var Columns=[[ 
		{checkbox:true},
		{field:'DocDesc',title:'ҽ��',width:180,
			formatter:function(val,row){
				return '<a id= "AFRegDoc_' + row["DocId"] + '"onmouseover="ShowRDAPPNumStr(this)">'+val+'</a>';
			}
		},
		{field:'DocId',title:'ID',hidden:true},
		{field:'ChooseFlag',title:'ChooseFlag',hidden:true},
		{field:'RDAPPNum',title:'ԤԼ����',width:80,editor:{type:'numberbox',precision:0}},
		{field:'LocId',title:'LocId',hidden:true},
		{field:'LocDesc',title:'����',width:80},
    ]]
	PageLogicObj.m_AFRegDocListTabDataGrid=$("#AFRegDocListTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : false,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		rownumbers : false,  
		pageSize: 100,
		pageList : [50,100,999],
		idField:'DocId',
		columns :Columns,
		url:$URL+"?ClassName=web.DHCDocRegDocAppiont&QueryName=RBResDrList&LocIDs=&QryDesc=&DocFlag=Y&ExpStr=&HospID=",
		onBeforeLoad:function(param){
			var HospID=$HUI.combogrid('#_HospList').getValue();
			$("#AFRegDocListTab").datagrid("uncheckAll");
			var desc=$("#AFFindRegDoc").searchbox('getValue');
			if(PageLogicObj.m_AFRegLocListTabDataGrid=="") return;
			var RegLocSelrow=PageLogicObj.m_AFRegLocListTabDataGrid.datagrid("getChecked");
			var LocIDArr=[];
			for(var i=0;i<RegLocSelrow.length;i++){
				LocIDArr.push(RegLocSelrow[i]["CTCode"]);
			}
			if(LocIDArr.length<1) return;
			var LocIDs=LocIDArr.join("^");
			var QLocIds=LocIDArr.join("$");
			
			var AppDocSelrow=PageLogicObj.m_AFAppMarkListTabDataGrid.datagrid("getChecked");
			var AppMarkIDArr=[];
			for(var i=0;i<AppDocSelrow.length;i++){
				AppMarkIDArr.push(AppDocSelrow[i]["DocId"]);
			}
			var AppMarkIDs=(AppMarkIDArr.length>0)? AppMarkIDArr.join("$"):"";
			
			var ExtStr=AppMarkIDs==""?"":"AF^"+QLocIds+"^"+AppMarkIDs;
			
			param = $.extend(param,{LocIDs:LocIDs,QryDesc:desc,HospID:HospID,ExtStr:ExtStr});
		},
		onLoadSuccess:function(data){
			for (var i=0;i<data.rows.length;i++){
				var PoweredFlag=data.rows[i].ChooseFlag;
				if (PoweredFlag=="Y") {
					PageLogicObj.m_AFRegDocListTabDataGrid.datagrid('selectRow',i);
				}
			}
		},
		onCheck:function(index,rows){
			PageLogicObj.m_AFRegDocListTabDataGrid.datagrid('beginEdit', index);
		},
		onUncheck:function(index,rows){
			//rows['RDAPPNum']="";
			PageLogicObj.m_AFRegDocListTabDataGrid.datagrid('endEdit', index);
		}
	});
	return;
} 

function AFFindRegLocChange(){
	PageLogicObj.m_AFRegLocListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}
function AFFindRegDocChange(){
	PageLogicObj.m_AFRegDocListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}
function AFFindAppLocChange(){
	PageLogicObj.m_AFAppLocListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}
function AFFindAppMarkChange(){
	PageLogicObj.m_AFAppMarkListTabDataGrid.datagrid("clearChecked").datagrid("load",{}).datagrid("reload");
}

///ͬ��ԤԼ����
function SynAPPNum(Type){
	var DataGrid="";
	if(Type=="RFMark"){
		DataGrid=PageLogicObj.m_RFAppMarkListTabDataGrid;
	}
	if(Type=="AFLoc"){
		DataGrid=PageLogicObj.m_AFRegLocListTabDataGrid;
	}
	if(Type=="AFDoc"){
		DataGrid=PageLogicObj.m_AFRegDocListTabDataGrid;
	}
	if(DataGrid=="") return;
	var CheckRows=DataGrid.datagrid("getChecked");
	if(CheckRows.length<1) {
		$.messager.alert("��ʾ","��ѡ����Ҫͬ��������!")
		return;}
	var LastCheckRow=CheckRows[CheckRows.length-1];
	var SynRowIndex=DataGrid.datagrid("getRowIndex",LastCheckRow);
	DataGrid.datagrid('endEdit',SynRowIndex);
	CheckRows=DataGrid.datagrid("getChecked");
	var SynNum=CheckRows[CheckRows.length-1]['RDAPPNum'];
	if(SynNum<0){
		$.messager.alert("��ʾ","ԤԼ��������Ϊ����!")
		return;
	}
	
	$.messager.confirm("ͬ��","�Ƿ�ȷ�Ͻ����ѡ���е�ԤԼ����[ "+SynNum+" ]ͬ��������ѡ����?",function(r){
		if(!r) return;
		for(var i=0;i<CheckRows.length;i++){
			var rows=CheckRows[i];
			var index=DataGrid.datagrid("getRowIndex",rows);
			rows['RDAPPNum']=SynNum;
			DataGrid.datagrid('updateRow',{index:index,row:rows}).datagrid('endEdit',index).datagrid("beginEdit",index);
		}
	})
}

///���������:����-ҽ��-�ű� ��֯����:����1$ҽ��1#����2$ҽ��2...^�ű�1$����1#�ű�2$����2...!ɾ���ű�1$ɾ���ű�2
function GetRFDocDataOnMulSave(){
	var DataStr="",LocDocArr=new Array(),MarkArr=new Array(),DelMarkArr=new Array();
	MarkTab=PageLogicObj.m_RFAppMarkListTabDataGrid
	DocTab=PageLogicObj.m_RFRegDocListTabDataGrid
	var DocSelectRows=DocTab.datagrid("getChecked");
	for(var DocInd=0;DocInd<DocSelectRows.length;DocInd++){
		var DocItemRow=DocSelectRows[DocInd];
		var DocId=DocItemRow['DocId'];
		var LocId=DocItemRow['LocId'];
		var LocDocItem=LocId+"$"+DocId;
		LocDocArr.push(LocDocItem);
		
	}
	
	var MarkSelectRows=MarkTab.datagrid("getChecked");
	var MarkRows=MarkTab.datagrid("getRows");
	for(var MarkInd=0;MarkInd<MarkRows.length;MarkInd++){
		MarkTab.datagrid('endEdit',MarkInd);
		var MarkItemRow=MarkTab.datagrid("getRows")[MarkInd];
		var MarkId=MarkItemRow['DocId'];
		
		if ($.hisui.indexOfArray(MarkSelectRows,"DocId",MarkId)>=0) {
			//��Ϊѡ����,�򱣴�
			var MarkAPPNum=MarkItemRow['RDAPPNum'];
			if(MarkAPPNum<0){
				$.messager.alert("��ʾ","ԤԼ��������Ϊ����!")
				return "";
			}
			var MarkItem=MarkId+"$"+MarkAPPNum;
			MarkArr.push(MarkItem);
		}else{
			//��ԤԼ�ű�δ��ѡ��,���ж��Ƿ�����ɾ����
			if(MarkItemRow['ChooseFlag']=="Y"){
				DelMarkArr.push(MarkId)
			}
		}
	}
	if((LocDocArr.length>0)&&((MarkArr.length>0)||(DelMarkArr.length>0))){
		DataStr=LocDocArr.join("#")+"^"+ MarkArr.join("#") +"^"+DelMarkArr.join("#");
	}
	return DataStr;
}

///���������:����-�ű� ��֯����:����1#����2...^�ű�1$����1#�ű�2$����2...!ɾ���ű�1$ɾ���ű�2
function GetRFLocDataOnMulSave(){
	var DataStr="",LocArr=new Array(),MarkArr=new Array(),DelMarkArr=new Array();
	RegLocTab=PageLogicObj.m_RFRegLocListTabDataGrid
	MarkTab=PageLogicObj.m_RFAppMarkListTabDataGrid
	
	var LocSelectRows=RegLocTab.datagrid("getChecked");
	//start for1
	for(var LocInd=0;LocInd<LocSelectRows.length;LocInd++){
		var LocItemRow=LocSelectRows[LocInd];
		var LocId=LocItemRow['CTCode'];
		LocArr.push(LocId);
	}
	var MarkSelectRows=MarkTab.datagrid("getChecked");
	var MarkRows=MarkTab.datagrid("getRows");
	for(var MarkInd=0;MarkInd<MarkRows.length;MarkInd++){
		MarkTab.datagrid('endEdit',MarkInd);
		var MarkItemRow=MarkTab.datagrid("getRows")[MarkInd];
		var MarkId=MarkItemRow['DocId'];
		
		if ($.hisui.indexOfArray(MarkSelectRows,"DocId",MarkId)>=0) {
			//��Ϊѡ����,�򱣴�
			var MarkAPPNum=MarkItemRow['RDAPPNum'];
			if(MarkAPPNum<0){
				$.messager.alert("��ʾ","ԤԼ��������Ϊ����!")
				return "";
			}
			var MarkItem=MarkId+"$"+MarkAPPNum;
			MarkArr.push(MarkItem);
		}else{
			//��ԤԼ�ű�δ��ѡ��,���ж��Ƿ�����ɾ����
			if(MarkItemRow['ChooseFlag']=="Y"){
				DelMarkArr.push(MarkId)
			}
		}
	}
	
	if((LocArr.length>0)&&((MarkArr.length>0)||(DelMarkArr.length>0))){
		DataStr=LocArr.join("#")+"^"+ MarkArr.join("#") +"^"+DelMarkArr.join("#");
	}
	return DataStr;
}


///��ԤԼ����: ����-�ű� ���𱣴� ��֯����:�ű�1#�ű�2...^����1$����1#����2$����2...!ɾ������1$ɾ������2
function GetAFLocDataOnMulSave(){
	var DataStr="",MarkArr=new Array(),LocArr=new Array(),DelLocArr=new Array();

	RegLocTab=PageLogicObj.m_AFRegLocListTabDataGrid
	MarkTab=PageLogicObj.m_AFAppMarkListTabDataGrid
	
	var MarkSelectRows=MarkTab.datagrid("getChecked");
	for(var MarkInd=0;MarkInd<MarkSelectRows.length;MarkInd++){
		var MarkItemRow=MarkSelectRows[MarkInd];
		var MarkId=MarkItemRow['DocId'];
		MarkArr.push(MarkId)
	}
	
	var LocRows=RegLocTab.datagrid("getRows");
	var LocSelectRows=RegLocTab.datagrid("getChecked");
	for(LocInd=0;LocInd<LocRows.length;LocInd++){
		RegLocTab.datagrid('endEdit',LocInd);
		var LocItemRow=RegLocTab.datagrid("getRows")[LocInd];
		var LocId=LocItemRow['CTCode'];
		
		if ($.hisui.indexOfArray(LocSelectRows,"CTCode",LocId)>=0) {
			var LocAPPNum=LocItemRow['RDAPPNum'];
			if(LocAPPNum<0){
				$.messager.alert("��ʾ","ԤԼ��������Ϊ����!")
				return "";
			}
			var LocItem=LocId+"$"+LocAPPNum;
			LocArr.push(LocItem);
		}else{
			//���������δ��ѡ��,���ж��Ƿ�����ɾ����
			if(LocItemRow['ChooseFlag']=="Y"){
				DelLocArr.push(LocId)
			}
		}
	}
	
	if((MarkArr.length>0)&&((LocArr.length>0)||(DelLocArr.length>0))){
		DataStr=MarkArr.join("#")+"^"+ LocArr.join("#") +"^"+DelLocArr.join("#");
	}
	return DataStr;
}
///��ԤԼ����: ����-ҽ��-�ű� ���𱣴� ��֯����:�ű�1#�ű�2...^����1$ҽ��1$����1#����2$ҽ��2$����2...!ɾ������1$ɾ���ű�1#ɾ������2$ɾ���ű�2
function GetAFDocDataOnMulSave(){
	var DataStr="",MarkArr=new Array(),LocDocArr=new Array(),DelLocDocArr=new Array();

	DocTab=PageLogicObj.m_AFRegDocListTabDataGrid
	MarkTab=PageLogicObj.m_AFAppMarkListTabDataGrid
	
	var MarkSelectRows=MarkTab.datagrid("getChecked");
	for(var MarkInd=0;MarkInd<MarkSelectRows.length;MarkInd++){
		var MarkItemRow=MarkSelectRows[MarkInd];
		var MarkId=MarkItemRow['DocId'];
		MarkArr.push(MarkId);
	}
	var DocRows=DocTab.datagrid("getRows");
	var DocSelectRows=DocTab.datagrid("getChecked");
	for(DocInd=0;DocInd<DocRows.length;DocInd++){
		DocTab.datagrid('endEdit',DocInd);
		var DocItemRow=DocTab.datagrid("getRows")[DocInd];
		var DocId=DocItemRow['DocId'];
		var LocId=DocItemRow['LocId'];
		
		if ($.hisui.indexOfArray(DocSelectRows,"DocId",DocId)>=0) {
			var DocAPPNum=DocItemRow['RDAPPNum'];
			if(DocAPPNum<0){
				$.messager.alert("��ʾ","ԤԼ��������Ϊ����!")
				return "";
			}
			var LocDocItem=LocId+"$"+DocId+"$"+DocAPPNum;
			LocDocArr.push(LocDocItem);
		}else{
			//������ҽ��δ��ѡ��,���ж��Ƿ�����ɾ����
			if(DocItemRow['ChooseFlag']=="Y"){
				var DelItem=LocId+"$"+DocId;
				DelLocDocArr.push(DelItem)
			}
		}
	}
	if((MarkArr.length>0)&&((LocDocArr.length>0)||(DelLocDocArr.length>0))){
		DataStr=MarkArr.join("#")+"^"+ LocDocArr.join("#") +"^"+DelLocDocArr.join("#");
	}
	return DataStr;
}


function GetDataOnMulSave(Type){
	var SaveData="";
	if(Type=="AFLoc") SaveData=GetAFLocDataOnMulSave();
	if(Type=="AFDoc") SaveData=GetAFDocDataOnMulSave();
	
	if(Type=="RF"){
		DocTab=PageLogicObj.m_RFRegDocListTabDataGrid
		var DocSelectRows=DocTab.datagrid("getChecked");
		if(DocSelectRows.length>0){
			Type="RFDoc";
			SaveData=GetRFDocDataOnMulSave();
		}else{
			Type="RFLoc";	
			SaveData=GetRFLocDataOnMulSave();
		}
	}
	return {SaveData:SaveData,SaveType:Type};
	
}

//��������
function MulSaveToServer(Type){
	var SaveDataObj=GetDataOnMulSave(Type);
	var SaveData=SaveDataObj['SaveData'];
	var SaveType=SaveDataObj['SaveType'];
	if(SaveData=="")return;
	$.cm({
		ClassName:"web.DHCDocRegDocAppiont",
		MethodName:"MulSetUserCanDo",
		SaveData:SaveData,
		SaveType:SaveType,
		dataType:"text",
	},function(rtn){
		var rtnArr=rtn.split("^");
		if (rtnArr[0]==0){
			$.messager.show({title:"��ʾ",msg:"�����ɹ�"});
			
		}else{
			$.messager.alert("��ʾ","����ʧ��!"+rtnArr[1])
		}
		//SwitchTab();
		if(Type=="RF"){
			InitRFAppMarkListTabDataGrid();	
		}
		if(Type=="AFLoc"){
			InitAFRegLocListTabDataGrid();	
		}
		if(Type=="AFDoc"){
			InitAFRegDocListTabDataGrid();	
		}
		
	});	
}

/**�����������**/

