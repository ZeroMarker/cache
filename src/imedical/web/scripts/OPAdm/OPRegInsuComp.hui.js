var PageLogicObj={
	m_DHCOPRegInsuCompDataGrid:"",
	m_SelectLookup:false,
	m_NowOrdItemDr:"",
	m_UploadOrdItemDr:"",
};
$(function(){
	Init();
	InitEvent();
	DHCOPRegInsuCompDataGridLoad();
});
function Init(){
	InitAdmReason();
	InitArcimList("NowOrdItem");
	InitArcimList("UploadOrdItem");
	PageLogicObj.m_DHCOPRegInsuCompDataGrid=InitDHCOPRegInsuCompDataGrid();
}

function InitEvent(){
	$('#BAdd').click(AddClickHandle);
	$('#BFind').click(DHCOPRegInsuCompDataGridLoad);
	$('#BClear').click(ClearData);
	$('#InsuPatTypeCode').change(AdmReasonSet);
	$(document.body).bind("keydown",BodykeydownHandler)
}

function InitDHCOPRegInsuCompDataGrid(){
	var toobar=[{
        text: '新增',
        iconCls: 'icon-add',
        handler: function() { AddClickHandle();}
    },{
        text: '修改',
        iconCls: 'icon-update',
        handler: function() { UpdateClickHandle();}
    },{
        text: '删除',
        iconCls: 'icon-remove',
        handler: function() { DeleteClickHandle();}
    }];
	var Columns=[[ 
		{field:'TRowid',hidden:true,title:''},
		{field:'TabAdmReason',title:'患者类型',width:200},
		{field:'TabInsuPatTypeCode',title:'医保患者类型代码',width:200},
		{field:'TabNowOrdItem',title:'现医嘱项目',width:300},
		{field:'TabUploadOrdItem',title:'上传医嘱项目',width:300},
		{field:'TabStartDate',title:'开始日期',width:200},
		{field:'TabEndDate',title:'结束日期',width:200},
		{field:'TabUploadOrdItemDr',hidden:true,title:'',width:30},
		{field:'TabNowOrdItemDr',hidden:true,title:'',width:30},
		{field:'AdmReasonRowid',hidden:true,title:'',width:30},
    ]]
	var DHCOPRegInsuCompDataGrid=$("#DHCOPRegInsuCompTab").datagrid({
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
		idField:'TRowid',
		columns :Columns,
		toolbar:toobar,
		onSelect:function(index, row){
			SetSelRowData(row);
		},
		onUnselect:function(index, row){
			ClearData();
		},
		onBeforeSelect:function(index, row){
			var selrow=PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('getSelected');
			if (selrow){
				var oldIndex=PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('getRowIndex',selrow);
				if (oldIndex==index){
					PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('unselectRow',index);
					return false;
				}
			}
		}
	}); 
	return DHCOPRegInsuCompDataGrid;
}

function SetSelRowData(row){
	var TRowid=row["TRowid"];
	if(TRowid=="")return;
	var AdmReasonRowid=row["AdmReasonRowid"]
	var TabInsuPatTypeCode=row["TabInsuPatTypeCode"];
	var TabStartDate=row["TabStartDate"];
	var TabEndDate=row["TabEndDate"];
	var TabUploadOrdItemDr=row["TabUploadOrdItemDr"];
	var TabNowOrdItemDr=row["TabNowOrdItemDr"];
	var UploadOrdItemDesc=row["TabUploadOrdItem"];
	var NowOrdItemDesc=row["TabNowOrdItem"];
	$('#InsuPatTypeCode').val(TabInsuPatTypeCode);
	$HUI.datebox("#StartDate").setValue(TabStartDate);
	$HUI.datebox("#EndDate").setValue(TabEndDate);
	$HUI.combobox('#AdmReason').setValue(AdmReasonRowid);	
	PageLogicObj.m_NowOrdItemDr=TabNowOrdItemDr;
	$("#NowOrdItem").lookup('setText',NowOrdItemDesc);
	PageLogicObj.m_UploadOrdItemDr=TabUploadOrdItemDr;
	$("#UploadOrdItem").lookup('setText',UploadOrdItemDesc);
	if(TabInsuPatTypeCode!=""){
		$HUI.combobox("#AdmReason").setValue("");
		$HUI.combobox("#AdmReason").disable()
	}else{
		$HUI.combobox("#AdmReason").enable()
	}	
	if(AdmReasonRowid!=""){
		$("#InsuPatTypeCode").val("");
		$("#InsuPatTypeCode").attr("disabled",true);
	}else{
		$("#InsuPatTypeCode").attr("disabled",false);
	}
}

function AddClickHandle(){
	if (!CheckDataValid()) return false;
	var InsuPatTypeCode=$('#InsuPatTypeCode').val();
	var AdmReason=$HUI.combobox("#AdmReason").getValue();
	AdmReason=CheckComboxSelData("AdmReason",AdmReason)
		
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var Rowid="";
	var InString=Rowid+"^"+AdmReason+"^"+EndDate+"^"+InsuPatTypeCode+"^"+PageLogicObj.m_NowOrdItemDr+"^"+StartDate+"^"+PageLogicObj.m_UploadOrdItemDr;
	$.cm({
		ClassName:"web.DHCOPRegInsuComp",
		MethodName:"Insert",
		InStr:InString,
	},function(rtn){
		if (rtn>0){
			$.messager.show({title:"提示",msg:"新增成功"});
			PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('uncheckAll');
			ClearData();
			DHCOPRegInsuCompDataGridLoad();
		}else{
			$.messager.alert("提示","新增失败!错误代码:"+rtn,"error");
			return false;
		}
	});
}

function ClearData(){
	$HUI.combobox("#AdmReason").setValue("");
	$("#InsuPatTypeCode").val("");
	$HUI.datebox("#StartDate").setValue("");
	$HUI.datebox("#EndDate").setValue("");
	$("#NowOrdItem,#UploadOrdItem").lookup("setText","");
	PageLogicObj.m_NowOrdItemDr="";
	PageLogicObj.m_UploadOrdItemDr="";
	$HUI.combobox("#AdmReason").enable();
	$("#InsuPatTypeCode").attr("disabled",false);	
}

function CheckDataValid(){
	var code=$('#InsuPatTypeCode').val();
	var AdmReason=$HUI.combobox("#AdmReason").getValue();
	AdmReason=CheckComboxSelData("AdmReason",AdmReason)
	if((code=="")&&(AdmReason=="")){
		$.messager.alert("提示","请确定费别或医保病人代码","info");
		return false
	}	
	
	if (PageLogicObj.m_NowOrdItemDr==""){
		$.messager.alert("提示","请选择现医嘱项目","info");
		return false;
	}
	
	if (PageLogicObj.m_UploadOrdItemDr==""){
		$.messager.alert("提示","请选择上传医嘱项目","info");
		return false;
	}
		
	var StartDate=$HUI.datebox("#StartDate").getValue();
	if (StartDate==""){
		$.messager.alert("提示","缺少有效开始日期","info",function(){$("#StartDate").focus();});
		return false;
	}
	var EndDate=$HUI.datebox("#EndDate").getValue();
	if (EndDate==""){
		//$.messager.alert("提示","缺少有效截止日期","info",function(){$("#EndDate").focus();});
		//return false;
	}
	if((StartDate!="")&&(EndDate!="")){
		var Rtn=CompareDate(StartDate,EndDate)
		if (!Rtn){
			$.messager.alert("提示","结束日期不能小于开始日期!","info");
			return Rtn
		}
	}
	
	return true;
}
function DHCOPRegInsuCompDataGridLoad(){
	var InsuPatTypeCode=$('#InsuPatTypeCode').val();
	var AdmReason=$HUI.combobox("#AdmReason").getValue();
	AdmReason=CheckComboxSelData("AdmReason",AdmReason)
		
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	$.q({
	    ClassName : "web.DHCOPRegInsuComp",
	    QueryName : "RCFAdmReason",
	    'AdmReason':AdmReason,
	    'InsuPatTypeCode':InsuPatTypeCode,
	    'NowOrdItemDr':PageLogicObj.m_NowOrdItemDr,
	    'UploadOrdItemDr':PageLogicObj.m_UploadOrdItemDr,
	    'StartDate':StartDate,
	    'EndDate':EndDate,
	    Pagerows:PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('clearSelections'); 
		PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('clearChecked'); 
	}); 
}

function DeleteClickHandle(){
	var Rowid="";
	var row=PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要删除的记录!","info");
		return false;
	}
	Rowid=row.TRowid;	
	$.cm({
		ClassName:"web.DHCOPRegInsuComp",
		MethodName:"Delete",
		Rowid:Rowid,
	},function(rtn){
		if (rtn==0){
			$.messager.show({title:"提示",msg:"删除成功"});
			PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('uncheckAll');
			ClearData();
			DHCOPRegInsuCompDataGridLoad();
		}else{
			$.messager.alert("提示","删除失败!错误代码:"+rtn,"error");
			return false;
		}
	});	
}

function UpdateClickHandle(){
	var Rowid="";
	var row=PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('getSelected');
	if ((!row)||(row.length==0)){
		$.messager.alert("提示","请选择需要更新的记录!","info");
		return false;
	}
	Rowid=row.TRowid;	
	if (!CheckDataValid()) return false;
	var InsuPatTypeCode=$('#InsuPatTypeCode').val();
	var AdmReason=$HUI.combobox("#AdmReason").getValue();
	AdmReason=CheckComboxSelData("AdmReason",AdmReason)
		
	var StartDate=$HUI.datebox("#StartDate").getValue();
	var EndDate=$HUI.datebox("#EndDate").getValue();
	var InString=Rowid+"^"+AdmReason+"^"+EndDate+"^"+InsuPatTypeCode+"^"+PageLogicObj.m_NowOrdItemDr+"^"+StartDate+"^"+PageLogicObj.m_UploadOrdItemDr;
	$.cm({
		ClassName:"web.DHCOPRegInsuComp",
		MethodName:"Update",
		InStr:InString,
	},function(rtn){
		if (rtn>0){
			$.messager.show({title:"提示",msg:"修改成功"});
			PageLogicObj.m_DHCOPRegInsuCompDataGrid.datagrid('uncheckAll');
			ClearData();
			DHCOPRegInsuCompDataGridLoad();
		}else{
			$.messager.alert("提示","修改失败!错误代码:"+rtn,"error");
			return false;
		}
	});
}

function InitAdmReason(){
	var getData=$.cm({
		ClassName:"web.DHCOPRegInsuComp",
		MethodName:"FeeCate",
		dataType:"text"	
	},false)
	var DataArr=new Array()
	var oneValue = {"value":"", "desc":"请选择..."};
	DataArr.push(oneValue);
	if(getData!=""){
		var len=getData.split("!").length		
		for(var i=0;i<len;i++){
			var oneValue=getData.split("!")[i];
			var value=oneValue.split("^")[0];
			if(value=="")continue;
			var desc=oneValue.split("^")[1];
			var oneValue = {"value":value, "desc":desc};
			DataArr.push(oneValue);
		}
	}
	$HUI.combobox('#AdmReason',{      
    	valueField:'value',   
    	textField:'desc',
    	data: DataArr,
		editable:false,
    	onLoadSuccess:function(){
			$HUI.combobox('#AdmReason').setValue("");
		},onSelect:function(record){
			if(record.value!=""){
				$("#InsuPatTypeCode").val("");
				$("#InsuPatTypeCode").attr("disabled",true);
			}else{
				$("#InsuPatTypeCode").attr("disabled",false);	
			}
		}
	});			
}

function InitArcimList(itemname){
	 $HUI.lookup("#"+itemname,{
        url:$URL,
        mode:'remote',
        disabled:false,
        method:"Get",
        idField:'ALIASARCIMDR',
        textField:'ARCIMDesc',
        columns:[[  
            {field:'ARCIMDesc',title:'名称',width:320,sortable:true},
			{field:'ALIASARCIMDR',title:'ID',width:100,sortable:true},
        ]],
        pagination:true,
        panelWidth:450,
        panelHeight:420,
        isCombo:true,
        minQueryLen:2,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 10,
		pageList: [10],
        delay:'300',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCOPRegInsuComp',QueryName: 'orderlookup'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{'desc':desc});
	    },onSelect:function(ind,item){
            var Desc=item['ARCIMDesc'];
			var ID=item['ALIASARCIMDR'];
			$HUI.lookup("#"+itemname).hidePanel();
			PageLogicObj.m_SelectLookup=true;
			if(itemname=="NowOrdItem")PageLogicObj.m_NowOrdItemDr=ID;
			if(itemname=="UploadOrdItem")PageLogicObj.m_UploadOrdItemDr=ID;
		}
    });
}

function AdmReasonSet(){
	var code=$('#InsuPatTypeCode').val();
	if(code!=""){
		$HUI.combobox("#AdmReason").setValue("");
		$HUI.combobox("#AdmReason").disable()
	}else{
		$HUI.combobox("#AdmReason").enable()
	}	
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
        //e.preventDefault(); 
        return false;  
    }  
}
function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="Dept"){
			var CombValue=Data[i].CTCode;
		 	var CombDesc=Data[i].CTDesc;
	     }else if (id=="AdmReason"){
		    var CombValue=Data[i].value  
		 	var CombDesc=Data[i].desc
		 }
		 if(selId==CombValue){
			 selId=CombValue;
			 Find=1;
			 break;
	     }
	  }
	  if (Find=="1") return selId
	  return "";
}