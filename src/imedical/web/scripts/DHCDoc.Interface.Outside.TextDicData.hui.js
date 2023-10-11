var PageLogicObj={
	m_TextDicDataGrid:"",
	m_ExtOrgWin:"",
	m_ExtOrgGrid:""
};
function Init(){
	InitEditTypeList();
	PageLogicObj.m_TextDicDataGrid=InitTableTextDicDataGrid();
	PageLogicObj.m_ExtOrgGrid=InitExtOrgGrid();
	InitEvent();
	InitDataCompareExtOrg();
	TextDicDataGridLoad();
}

function InitEvent(){
	$('#btnSave').click(SaveFormData);	
	
	$('#i-find').click(TextDicDataGridLoad);
	$('#i-ExtOrg').click(ExtOrgHandle);
	document.onkeydown = Doc_OnKeyDown;
}

function InitEditTypeList(){
	var EditTypeArr=new Array();
	//var person = {"value":"", "desc":"��ѡ��--"};
	//EditTypeArr.push(person);
	var EditTypeStrStr=$.cm({
		ClassName : "web.DHCDocTextDicDataCtl",
	    MethodName : "QueryMedDicList",	
	    Type:"SYS",
	    Flag:"",
	    dataType:"text",
	},false)
	var ArrData = EditTypeStrStr.split(String.fromCharCode(1));
	for (var i = 0; i < ArrData.length; i++) {
		var ArrData1 = ArrData[i].split("^")
		var value=ArrData1[1];
		var desc=ArrData1[1]+"--"+ArrData1[2];
		var person = {"value":value, "desc":desc};
		EditTypeArr.push(person);
	}
	var root = {"value":"SYS", "desc":"���ֵ�"};
	EditTypeArr.push(root);
	$HUI.combobox('#SDicType,#EditType',{      
    	valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
		editable:true,
    	onLoadSuccess:function(){
			$(this).combobox("setValue","");
		},onChange: function (n,o) {
			//if((n=="")||(typeof n == "undefined")){
			//	$(this).combobox("select","")
				//TextDicDataGridLoad();
			//}
		},
		filter:function(q, row){
			return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});	
	$HUI.combobox('#EditType',{
		onSelect:function(){
			var boxvalue=$('#EditType').combobox('getValue');
			if(boxvalue=="SYS"){
				$("#EditExtOrg").combobox("disable");
				$("#EditExtOrg").combobox("setValue","");
			}else{
				$("#EditExtOrg").combobox("enable");
				$("#EditExtOrg").combobox("setValue","");
			}
		}
	});
	$HUI.combobox('#SDicType',{
		onSelect:function(){
			TextDicDataGridLoad();
		}
	});
}

function Doc_OnKeyDown(e){
	//��ֹ�ڿհ״����˸���������Զ����˵���һ������
	if (!websys_cancelBackspace(e)) return false;
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
        e.preventDefault();   
    }  
    /*if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        return false;
	}*/
}

function AddGridData(){
	$("#add-dialog").dialog("open");
	//��ձ�����
	$('#add-form').form("clear");
	Clear();
}

function InitTableTextDicDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
	    	AddGridData();
	    }
    }, {
        text: '�޸�',
        iconCls: 'icon-update',
        handler: function() { UpdateGridData();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:''},
		{field:'Type',title:'�ֵ����',width:300},
		{field:'Code',title:'����մ���',width:300},
		{field:'Desc',title:'���������',width:300},
		{field:'Active',title:'�Ƿ�����',width:100},
		{field:'DateFrom',title:'��ʼ����',width:300,hidden:true},
		{field:'DateTo',title:'��ֹ����',width:300,hidden:true},
		{field:'StrCode',title:'���մ���',width:300},
		{field:'StrDesc',title:'��������',width:300},
		{field:'StrHisFlag',title:'�ⲿ��His����',width:300},
		{field:'ExtOrg',title:'�ⲿ����',width:300},
		{field:'ExtOrgId',title:'ExtOrgId',width:30,hidden:true}
    ]]
	var TextDicDataGrid=$("#table_textdicdata").datagrid({
		fit : true,
		border : false,
		striped : false,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,50,100],
		idField:'Rowid',
		columns :Columns,
		toolbar:toobar,
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_TextDicDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_TextDicDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_TextDicDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return TextDicDataGrid;	
}

function SaveFormData(){
	if(!CheckData()) return false;  
	
	var EditRowid=$.trim($("#EditRowid").val());
	var EditType=$HUI.combobox('#EditType').getValue();
	var EditCode=$.trim($("#EditCode").val());
	var EditDesc=$.trim($("#EditDesc").val());
	var EditDateFrom=""; //$HUI.datebox("#EditDateFrom").getValue();
	var EditDateTo=""; //$HUI.datebox("#EditDateTo").getValue();
	var EditStrCode=$.trim($("#EditStrCode").val()); 
	var EditStrDesc=$.trim($("#EditStrDesc").val());
	var EditHisFlag="N";
	if ($("#EditHisFlag").is(":checked")) {
		EditHisFlag="Y";
	}
	var EditActiveFlag="N";
	if ($("#EditActive").is(":checked")) {
		EditActiveFlag="Y";
	}
	var EditExtOrg=$HUI.combobox('#EditExtOrg').getValue();
	var InputPara=EditRowid+"^"+EditCode+"^"+EditDesc+"^"+EditType+"^"+EditActiveFlag;
	var InputPara=InputPara+"^"+EditDateFrom+"^"+EditDateTo+"^"+EditStrCode+"^"+EditHisFlag+"^"+EditExtOrg;
	var InputPara=InputPara+"^"+EditStrDesc;
	//alert(InputPara)
	$.cm({
		ClassName:"web.DHCDocTextDicDataCtl",
		MethodName:"Update",
		'InPut':InputPara,
		dataType:"text",
	},function testget(value){
		if(value>0){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			if(EditRowid!=""){
				$("#add-dialog").dialog( "close" );
			}else{
				Clear("Y");
			}
			TextDicDataGridLoad();
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else if (value=="-1") err="����մ����ظ�";
			else err="����ʧ��,������룺"+value;
			$.messager.alert('��ʾ',err,"warning");   
			return false;
		}
	});
	if(EditType=="SYS"){
		InitEditTypeList();
	}
}

///�޸ı����
function UpdateGridData(){
	var rows = PageLogicObj.m_TextDicDataGrid.datagrid("getSelections");
	if (rows.length ==1) {
		$('#add-dialog').window('open');
		//��ձ�����
		$('#add-form').form("clear")
		if(rows[0].Active=="Y")
		{
			var AvailFlag=true
		}else{
			var AvailFlag=false
		}
		$HUI.checkbox("#EditActive").setValue(AvailFlag);
		if(rows[0].StrHisFlag=="Y")
		{
			var StrHisFlag=true
		}else{
			var StrHisFlag=false
		}
		$HUI.checkbox("#EditHisFlag").setValue(StrHisFlag);
		$HUI.combobox("#EditType").select(rows[0].Type);
		$HUI.combobox("#EditExtOrg").setValue(rows[0].ExtOrgId);
		$('#add-form').form("load",{
			EditRowid:rows[0].Rowid,
			EditCode:rows[0].Code,
			EditDesc:rows[0].Desc,
			EditDateFrom:rows[0].DateFrom,
			EditDateTo:rows[0].DateTo,
			EditStrCode:rows[0].StrCode,
			EditStrDesc:rows[0].StrDesc	 
		})
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }

}

function TextDicDataGridLoad(){
	var ExtOrgId=$HUI.combobox("#SExtOrg").getValue();
	var DicType=$HUI.combobox("#SDicType").getValue();
	$.q({
	    ClassName : "web.DHCDocTextDicDataCtl",
	    QueryName : "QueryAll",
	    SExtOrgId : ExtOrgId,
	    SDicType  : DicType,
	    Pagerows:PageLogicObj.m_TextDicDataGrid.datagrid("options").pageSize,rows:9999
	},function(GridData){
		PageLogicObj.m_TextDicDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function Clear(RCFlag){
	if(RCFlag!="Y"){
		$HUI.combobox('#EditType').setValue("");
	}
	$("#EditCode").val("");
	$("#EditDesc").val("");
	$HUI.datebox("#EditDateFrom").setValue("");
	$HUI.datebox("#EditDateTo").setValue("");
	$("#EditStrCode").val("");
	$("#EditStrDesc").val("");
	$HUI.checkbox("#EditHisFlag").setValue(false);
	$HUI.checkbox("#EditActive").setValue(true);
	$HUI.checkbox("#EditHisFlag",{checked:false});
	$HUI.checkbox("#EditActive",{checked:true});
	$HUI.combobox('#EditExtOrg').setValue("");
}

function CheckData(){
	var EditType=$HUI.combobox('#EditType').getValue();
	if(EditType==""){
		$.messager.alert("��ʾ","��ѡ���ֵ�����","info",function(){
			$("#EditType").focus();
		});
		return false;
	}
	if($("#EditCode").val()==""){
		$.messager.alert("��ʾ","���벻��Ϊ��","info",function(){
			$("#EditCode").focus();
		});
		return false;
	}
	if($("#EditDesc").val()==""){
		$.messager.alert("��ʾ","��������Ϊ��","info",function(){
			$("#EditDesc").focus();
		});
		return false;
	}
	var EditExtOrg=$HUI.combobox('#EditExtOrg').getValue();
	if((EditType!="SYS")&&(EditExtOrg=="")){
		$.messager.alert("��ʾ","�Ǹ��ֵ�,��ѡ���ⲿ����","info",function(){
			$("#EditExtOrg").focus();
		});
		return false;
	}
	//$HUI.datebox("#EditDateFrom").getValue();
	//$HUI.datebox("#EditDateTo").getValue();
	//$("#EditStrCode").val();
	return true;	
}

function ExtOrgHandle(){
	var cWin = $HUI.dialog('#i-ExtOrg-dialog', {
		title: "�ⲿ����ά��",
		width:680,
		height:500,
		iconCls: "icon-save",
		modal: true,
		minimizable:false,
		maximizable:false,
		collapsible:false,
		onClose: function () {
		}
	});
	$("#i-diag-ExtOrgCode,#i-diag-ExtOrgDesc").val("");
	$("#i-diag-ExtOrgActive").checkbox('setValue',false);
	PageLogicObj.m_ExtOrgWin = cWin;
	findExtOrg();
	$('#i-ExtOrg-dialog').window('open');
}

function InitExtOrgGrid(){
	var columns = [[
		{field:'TExtOrgCode',title:'��������',width:100},
		{field:'TExtOrgDesc',title:'��������',width:100},
		{field:'TExtOrgActiveFlag',title:'���ñ�ʶ',width:100},
		{field:'ExtOrgRowid',title:'ID',width:60,hidden:true}
    ]]
	var ExtOrgDataGrid = $("#tabExtOrg").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		rownumbers:true,
		//autoRowHeight : false,
		pagination : true,  
		pageSize: 10,
		pageList : [10,20,50],
		idField:'ExtOrgRowid',
		columns :columns,
		toolbar:[{
				text:'����',
				id:'i-extadd',
				iconCls: 'icon-add',
				handler:function(){
					SaveExtOrg("add")	
				}
			},{
				text:'�޸�',
				id:'i-extedit',
				iconCls: 'icon-write-order',
				handler:function(){
					SaveExtOrg("edit")	
				}
			}
		],
		onSelect:function(index,row){
			SetSelRowData(row)	
		},
		onUnselect:function(index, row){
			$("#i-diag-ExtOrgCode,#i-diag-ExtOrgDesc").val("");
			$("#i-diag-ExtOrgActive").checkbox('uncheck');
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_ExtOrgGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_ExtOrgGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_ExtOrgGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	});
	
	return ExtOrgDataGrid;
}

function SetSelRowData(row){
	$("#i-diag-ExtOrgCode").val(row["TExtOrgCode"]);
	$("#i-diag-ExtOrgDesc").val(row["TExtOrgDesc"]);
	var ActiveFlag=row["TExtOrgActiveFlag"];
	if (ActiveFlag=="Y") {
		$("#i-diag-ExtOrgActive").checkbox('check');
	}else{
		$("#i-diag-ExtOrgActive").checkbox('uncheck');
	}
}

function SaveExtOrg(param){
	var Code=$("#i-diag-ExtOrgCode").val();
	var Desc=$("#i-diag-ExtOrgDesc").val();
	var Rowid="";
	if(param=="edit"){
		var row=PageLogicObj.m_ExtOrgGrid.datagrid("getSelected");
		if(row){
			Rowid=row.ExtOrgRowid;
		}
		if(Rowid==""){
			$.messager.alert("��ʾ","��ѡ��һ������.","warning")	
			return false;
		}
	}
	if(Code==""){
		$.messager.alert("��ʾ","�������벻��Ϊ��.","warning",function(){
			$('#i-diag-ExtOrgCode').next('span').find('input').focus();		
		})	
		return false;
	}
	if(Desc==""){
		$.messager.alert("��ʾ","������������Ϊ��.","warning",function(){
			$('#i-diag-ExtOrgDesc').next('span').find('input').focus();	
		})	
		return false;
	}
	var ActiveFlag=$HUI.checkbox("#i-diag-ExtOrgActive").getValue();
	if(ActiveFlag){
		ActiveFlag="Y";
	}else{
		ActiveFlag="N";
	}
	
	$.cm({
		ClassName:"web.DHCDocExtData",
		MethodName:"SaveExtOrg",
		Code:Code,
		Desc:Desc,
		Active:ActiveFlag,
		Rowid:Rowid,
		dataType:"text"
	},function(val){
		if(val==0){
			$.messager.popover({msg:"�����ɹ�!",type:'success',timeout: 1000})	
			findExtOrg();
		}else{
			var msg="����ʧ��!"
			if(val=="1"){
				msg=msg+"�����ظ��Ĵ�������."	
			}
			else if(val=="2"){
				msg=msg+"�����ظ�����������."	
			}
			else{
				msg=msg+"�������:"+val;
			}
			$.messager.alert("����",msg,"error")	
		}	
	})
}
function findExtOrg(){
	$.cm({
	    ClassName : "web.DHCDocExtData",
	    QueryName : "ExtOrgDataQuery",
	    Pagerows:PageLogicObj.m_ExtOrgGrid.datagrid("options").pageSize,
	    rows:99999
	},function(GridData){
		PageLogicObj.m_ExtOrgGrid.datagrid("unselectAll");
		PageLogicObj.m_ExtOrgGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}

function InitDataCompareExtOrg(){
	$HUI.combobox("#EditExtOrg,#SExtOrg", {
		url:$URL+"?ClassName=web.DHCDocExtData&QueryName=ExtOrgDataQuery&Active=Y&ResultSetType=array",
		valueField:'ExtOrgRowid',
		textField:'TExtOrgDesc',
	});
	$HUI.combobox("#SExtOrg", {
		onSelect: function () {
			TextDicDataGridLoad();
		},onChange: function (n,o) {
			//if((n=="")||(typeof n == "undefined")){
			//	$(this).combobox("select","")
			//}
		},
		filter:function(q, row){
			return (row["TExtOrgDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});
}