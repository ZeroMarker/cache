var PageLogicObj={
	m_TextDicDataGrid:""
};
function Init(){
	InitEditTypeList();
	PageLogicObj.m_TextDicDataGrid=InitTableTextDicDataGrid();
	InitEvent()
	TextDicDataGridLoad();
}

function InitEvent(){
	$('#btnSave').bind('click', function(){
		if(!SaveFormData())return false;
	});	
	
	document.onkeydown = Doc_OnKeyDown;
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
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        return false;
	}
}

function InitTableTextDicDataGrid(){
	var toobar=[{
        text: '����',
        iconCls: 'icon-add',
        handler: function() {
	    	$("#add-dialog").dialog("open");
			//��ձ�����
			$('#add-form').form("clear");
			Clear();
	    }
    }, {
        text: '�޸�',
        iconCls: 'icon-update',
        handler: function() { UpdateGridData();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:''},
		{field:'Code',title:'�ⲿ����',width:300},
		{field:'Desc',title:'�ⲿ����',width:300},
		{field:'Type',title:'�ֵ����',width:300},
		{field:'Active',title:'״̬',width:200},
		{field:'DateFrom',title:'��ʼ����',width:300},
		{field:'DateTo',title:'��ֹ����',width:300},
		{field:'StrA',title:'His����',width:300},
		{field:'StrB',title:'�ⲿ��His����',width:300}
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
		onCheck:function(index, row){
			
		},		
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
	
	var EditRowid=$("#EditRowid").val();
	var EditType=$HUI.combobox('#EditType').getValue();
	var EditCode=$("#EditCode").val();
	var EditDesc=$("#EditDesc").val();
	var EditDateFrom=$HUI.datebox("#EditDateFrom").getValue();
	var EditDateTo=$HUI.datebox("#EditDateTo").getValue();
	var EditStrA=$("#EditStrA").val(); ;
	var EditStrBFlag="N";
	if ($("#EditStrB").is(":checked")) {
		EditStrBFlag="Y";
	}
	var EditActiveFlag="N";
	if ($("#EditActive").is(":checked")) {
		EditActiveFlag="Y";
	}
	var InputPara=EditRowid+"^"+EditCode+"^"+EditDesc+"^"+EditType+"^"+EditActiveFlag;
	var InputPara=InputPara+"^"+EditDateFrom+"^"+EditDateTo+"^"+EditStrA+"^"+EditStrBFlag;
	//alert(InputPara)
	$.cm({
		ClassName:"web.DHCDocTextDicDataCtl",
		MethodName:"Update",
		'InPut':InputPara,
		dataType:"text",
	},function testget(value){
		//alert(value)
		if(value){
			$.messager.show({title:"��ʾ",msg:"����ɹ�"});	
			$("#add-dialog").dialog( "close" );
			TextDicDataGridLoad();
			return true;							
		}else{
			var err=""
			if (value=="100") err="�����ֶβ���Ϊ��";
			else if (value=="101") err="�����ظ�";
			else err=value;
			$.messager.alert('Warning',err);   
			return false;
		}
	});
}

///�޸ı����
function UpdateGridData(){
	var rows = PageLogicObj.m_TextDicDataGrid.datagrid("getSelections");
	if (rows.length ==1) {
		$('#add-dialog').window('open').window('resize',{width:'400px',height:'400px',top: 100,left:400});
		//��ձ�����
		$('#add-form').form("clear")
		if(rows[0].Active=="Y")
		{
			var AvailFlag=true
		}else{
			var AvailFlag=false
		}
		$HUI.checkbox("#EditActive").setValue(AvailFlag);
		if(rows[0].StrB=="Y")
		{
			var StrBFlag=true
		}else{
			var StrBFlag=false
		}
		$HUI.checkbox("#EditStrB").setValue(StrBFlag);
		$HUI.combobox("#EditType").setValue(rows[0].Type);
		$('#add-form').form("load",{
			EditRowid:rows[0].Rowid,
			EditCode:rows[0].Code,
			EditDesc:rows[0].Desc,
			EditDateFrom:rows[0].DateFrom,
			EditDateTo:rows[0].DateTo,
			EditStrA:rows[0].StrA,	 
		})
     }else if (rows.length>1){
	     $.messager.alert("����","��ѡ���˶��У�",'err')
     }else{
	     $.messager.alert("����","��ѡ��һ�У�",'err')
     }

}

function TextDicDataGridLoad(){
	$.q({
	    ClassName : "web.DHCDocTextDicDataCtl",
	    QueryName : "QueryAll",
	    Pagerows:PageLogicObj.m_TextDicDataGrid.datagrid("options").pageSize,rows:9999
	},function(GridData){
		PageLogicObj.m_TextDicDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function Clear(){
	$HUI.combobox('#EditType').setValue("");
	$("#EditCode").val("");
	$("#EditDesc").val("");
	$HUI.datebox("#EditDateFrom").setValue("");
	$HUI.datebox("#EditDateTo").setValue("");
	$("#EditStrA").val("");
	$HUI.checkbox("#EditStrB").setValue(false);
	$HUI.checkbox("#EditActive").setValue(true);
	$HUI.checkbox("#EditStrB",{checked:false})
	$HUI.checkbox("#EditActive",{checked:true})
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
	var person = {"value":"SYS", "desc":"���ֵ�"};
	EditTypeArr.push(person);
	$HUI.combobox('#EditType',{      
    	valueField:'value',   
    	textField:'desc',
    	data: EditTypeArr,
		editable:false,
    	onLoadSuccess:function(){
			var sbox = $HUI.combobox("#EditType");
			sbox.clear();
		},onSelect:function(){
			var boxvalue=$('#EditType').combobox('getValue');
		}
	});		
}

function CheckData(){
	var EditType=$HUI.combobox('#EditType').getValue();
	if(EditType==""){
		$.messager.alert("��ʾ","��ѡ���ֵ�����");
		return false;
	}
	if($("#EditCode").val()==""){
		$.messager.alert("��ʾ","���벻��Ϊ��");
		return false;
	}
	if($("#EditDesc").val()==""){
		$.messager.alert("��ʾ","��������Ϊ��");
		return false;
	}
	//$HUI.datebox("#EditDateFrom").getValue();
	//$HUI.datebox("#EditDateTo").getValue();
	//$("#EditStrA").val();
	return true;	
}