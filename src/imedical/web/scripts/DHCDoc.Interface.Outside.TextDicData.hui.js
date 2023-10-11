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
	//var person = {"value":"", "desc":"请选择--"};
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
	var root = {"value":"SYS", "desc":"根字典"};
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
	//防止在空白处敲退格键，界面自动回退到上一个界面
	if (!websys_cancelBackspace(e)) return false;
	//浏览器中Backspace不可用  
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
	//清空表单数据
	$('#add-form').form("clear");
	Clear();
}

function InitTableTextDicDataGrid(){
	var toobar=[{
        text: '增加',
        iconCls: 'icon-add',
        handler: function() {
	    	AddGridData();
	    }
    }, {
        text: '修改',
        iconCls: 'icon-update',
        handler: function() { UpdateGridData();}
    }];
	var Columns=[[ 
		{field:'Rowid',hidden:true,title:''},
		{field:'Type',title:'字典类别',width:300},
		{field:'Code',title:'需对照代码',width:300},
		{field:'Desc',title:'需对照描述',width:300},
		{field:'Active',title:'是否启用',width:100},
		{field:'DateFrom',title:'起始日期',width:300,hidden:true},
		{field:'DateTo',title:'截止日期',width:300,hidden:true},
		{field:'StrCode',title:'对照代码',width:300},
		{field:'StrDesc',title:'对照描述',width:300},
		{field:'StrHisFlag',title:'外部到His对照',width:300},
		{field:'ExtOrg',title:'外部机构',width:300},
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
			$.messager.show({title:"提示",msg:"保存成功"});	
			if(EditRowid!=""){
				$("#add-dialog").dialog( "close" );
			}else{
				Clear("Y");
			}
			TextDicDataGridLoad();
			return true;							
		}else{
			var err=""
			if (value=="100") err="必填字段不能为空";
			else if (value=="-1") err="需对照代码重复";
			else err="保存失败,错误代码："+value;
			$.messager.alert('提示',err,"warning");   
			return false;
		}
	});
	if(EditType=="SYS"){
		InitEditTypeList();
	}
}

///修改表格函数
function UpdateGridData(){
	var rows = PageLogicObj.m_TextDicDataGrid.datagrid("getSelections");
	if (rows.length ==1) {
		$('#add-dialog').window('open');
		//清空表单数据
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
	     $.messager.alert("错误","您选择了多行！",'err')
     }else{
	     $.messager.alert("错误","请选择一行！",'err')
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
		$.messager.alert("提示","请选择字典类型","info",function(){
			$("#EditType").focus();
		});
		return false;
	}
	if($("#EditCode").val()==""){
		$.messager.alert("提示","代码不能为空","info",function(){
			$("#EditCode").focus();
		});
		return false;
	}
	if($("#EditDesc").val()==""){
		$.messager.alert("提示","描述不能为空","info",function(){
			$("#EditDesc").focus();
		});
		return false;
	}
	var EditExtOrg=$HUI.combobox('#EditExtOrg').getValue();
	if((EditType!="SYS")&&(EditExtOrg=="")){
		$.messager.alert("提示","非根字典,请选择外部机构","info",function(){
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
		title: "外部机构维护",
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
		{field:'TExtOrgCode',title:'机构代码',width:100},
		{field:'TExtOrgDesc',title:'机构描述',width:100},
		{field:'TExtOrgActiveFlag',title:'可用标识',width:100},
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
				text:'新增',
				id:'i-extadd',
				iconCls: 'icon-add',
				handler:function(){
					SaveExtOrg("add")	
				}
			},{
				text:'修改',
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
			$.messager.alert("提示","请选择一行数据.","warning")	
			return false;
		}
	}
	if(Code==""){
		$.messager.alert("提示","机构代码不能为空.","warning",function(){
			$('#i-diag-ExtOrgCode').next('span').find('input').focus();		
		})	
		return false;
	}
	if(Desc==""){
		$.messager.alert("提示","机构描述不能为空.","warning",function(){
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
			$.messager.popover({msg:"操作成功!",type:'success',timeout: 1000})	
			findExtOrg();
		}else{
			var msg="操作失败!"
			if(val=="1"){
				msg=msg+"存在重复的代码数据."	
			}
			else if(val=="2"){
				msg=msg+"存在重复的描述数据."	
			}
			else{
				msg=msg+"错误代码:"+val;
			}
			$.messager.alert("错误",msg,"error")	
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