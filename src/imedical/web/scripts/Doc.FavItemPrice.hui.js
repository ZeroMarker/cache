var PageLogicObj={
	m_PriceTabDataGrid:"",
}
$(function(){
	//初始化
	Init();
	//页面元素初始化
	PageHandle();
	IntEvent();
})
function IntEvent(){
	$(document.body).bind("keydown",BodykeydownHandler);
}
function PageHandle(){
	PriceTabDataGridLoad();
	IntHosp();
	InitZS();
}
function Init(){
	PageLogicObj.m_PriceTabDataGrid=InitPriceTabDataGrid();
}
function InitPriceTabDataGrid(){
	PageLogicObj.toolbar=[{
		id:"rePrint",
		text: '新增',
		iconCls: 'icon-add',
		handler: function(){AddClickHandler();}
	},{
		id:"Export",
		text: '修改',
		iconCls: 'icon-edit',
		handler: function(){UpdateClickHandler();}
	},{
		id:"Export",
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function(){DeleteClickHandler();}
	}]
	var Columns=[[ 
		{field:'TDateFrom',title:'开始日期',width:100},
		{field:'TDateTo',title:'结束日期',width:100},
		{field:'TTariff',title:'征收',width:150},
		{field:'TPrice',title:'价格',width:120,align:"right"},
		{field:'THospital',title:'医院',width:200},
		{field:'Pricerowid',title:'',hidden:true},
		{field:'TTariffrowid',title:'',hidden:true},
		{field:'Hospitalid',title:'',hidden:true}
    ]]
	var PriceTabDataGrid=$("#PriceTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		idField:'Pricerowid',
		columns :Columns,
		toolbar:PageLogicObj.toolbar,
		onSelect:function(index, row){
			setSelData(row);
		},onBeforeCheck:function(index, row){
			var row=PageLogicObj.m_PriceTabDataGrid.datagrid('getSelected');
			var oldIndex=PageLogicObj.m_PriceTabDataGrid.datagrid('getRowIndex');
			if (oldIndex==index){
				clearSelData();
				PageLogicObj.m_PriceTabDataGrid.datagrid('unselectRow',index);
				return false;
			}
		}
	});
	return PriceTabDataGrid;
}
function clearSelData(){
	$("#DateFrom,#DateTo").datebox('setValue','');
	$("#Price").val('');
	$("#Tariff").combobox('select',''); //#Hosp
}
function setSelData(row){
	$("#DateFrom").datebox('setValue',row['TDateFrom']);
	$("#DateTo").datebox('setValue',row['TDateTo']);
	$("#Price").val(row['TPrice']);
	$("#Tariff").combobox('select',row['TTariffrowid']);
	$("#Hosp").combobox('select',row['Hospitalid']);
}
function PriceTabDataGridLoad(){
	$.cm({
	    ClassName : "web.DHCUserFavItemPrice",
	    QueryName : "FindInfo",
	    ARCOSRowid:ServerObj.ARCOSRowid,
	    Pagerows:PageLogicObj.m_PriceTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_PriceTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	})
}
function IntHosp(){
	$.cm({
	    ClassName : "web.DHCUserFavItemPrice",
	    MethodName : "LookUpHospital",
	    itmjs:"HUIJSON",desc:""
	},function(Data){
		var cbox = $HUI.combobox("#Hosp", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				disabled:true,
				data: Data,
				onLoadSuccess:function(data){
					$("#Hosp").combobox('select',session['LOGON.HOSPID']);
				}
		 });
	})
}
function InitZS(){
	$.cm({
	    ClassName : "web.DHCUserFavItemPrice",
	    MethodName : "LookUpTariff",
	    itmjs:"HUIJSON",desc:""
	},function(Data){
		var cbox = $HUI.combobox("#Tariff", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				data: Data
		 });
	})
}
function AddClickHandler(){
	var DateFrom=$("#DateFrom").datebox('getValue');
	if (DateFrom==""){
		$.messager.alert("提示","开始日期不能为空!");
		return false;
	}
	var DateTo=$("#DateTo").datebox('getValue');
	var Tariff=getComValue("Tariff"); 
	if (Tariff==""){
		$.messager.alert("提示","请选择征收项目!");
		return false;
	}
	var Price=$.trim($("#Price").val());
	if (Price==""){
		$.messager.alert("提示","价格不能为空!","info",function(){
			$("#Price").focus();
		});
		return;
	}
	if (+Price<0){
		$.messager.alert("提示","价格不能为负数!","info",function(){
			$("#Price").focus();
		});
		return;
	}
	Price=Price.replace(/\s/g, "");
	var price=Number(Price)
	var price1=isNaN(price)
	if (price1==true){
		$.messager.alert("提示","价格处请输入数字!","info",function(){
			$("#Price").focus();
		});
		return false;
	}
	var Hospital=getComValue("Hosp"); 
	$.cm({
	    ClassName : "web.DHCUserFavItemPrice",
	    MethodName : "insert",
	    ARCOSRowid:ServerObj.ARCOSRowid, DateFrom:DateFrom, DateTo:DateTo, Tariff:Tariff, Price:Price, Hospital:Hospital,
	    dataType:'text'
	},function(ret){
		if (ret==0){
			$.messager.popover({msg: '新增成功!',type:'success',timeout: 1000});
			PageLogicObj.m_PriceTabDataGrid.datagrid('unselectAll');
			PriceTabDataGridLoad();
			clearSelData();
		}else{
			$.messager.alert("提示",ret);
		}
	})
}
function UpdateClickHandler(){
	var row=PageLogicObj.m_PriceTabDataGrid.datagrid('getSelected');
	if (!row){
		$.messager.alert("提示","请选择需要更新的记录!");
		return false;
	}
	var ARCOSRowidPrice=row['Pricerowid'];
	var DateFrom=$("#DateFrom").datebox('getValue');
	if (DateFrom==""){
		$.messager.alert("提示","开始日期不能为空!");
		return false;
	}
	var DateTo=$("#DateTo").datebox('getValue');
	var Tariff=getComValue("Tariff");
	if (Tariff==""){
		$.messager.alert("提示","请选择征收项目!");
		return false;
	}
	var Price=$.trim($("#Price").val());
	if (Price==""){
		$.messager.alert("提示","价格不能为空!","info",function(){
			$("#Price").focus();
		});
		return;
	}
	if (+Price<0){
		$.messager.alert("提示","价格不能为负数!","info",function(){
			$("#Price").focus();
		});
		return;
	}
	Price=Price.replace(/\s/g, "");
	var price=Number(Price)
	var price1=isNaN(price)
	if (price1==true){
		$.messager.alert("提示","价格处请输入数字!","info",function(){
			$("#Price").focus();
		});
		return false;
	}
	var Hospital=getComValue("Hosp"); 
	$.cm({
	    ClassName : "web.DHCUserFavItemPrice",
	    MethodName : "Update",
	    ARCOSRowidPrice:ARCOSRowidPrice, DateFrom:DateFrom, DateTo:DateTo, Tariff:Tariff, Price:Price, Hospital:Hospital,
	    dataType:'text'
	},function(ret){
		if (ret==0){ 
			$.messager.popover({msg: '保存成功!',type:'success',timeout: 1000});
			PageLogicObj.m_PriceTabDataGrid.datagrid('unselectAll');
			PriceTabDataGridLoad();
			clearSelData();
		}else{
			$.messager.alert("提示",ret);
		}
	})
}
function DeleteClickHandler(){
	var row=PageLogicObj.m_PriceTabDataGrid.datagrid('getSelected');
	if (!row){
		$.messager.alert("提示","请选择需要删除的记录!");
		return false;
	}
	var ARCOSRowidPrice=row['Pricerowid'];
	$.messager.confirm('确认对话框', '确定删除此行?', function(r){
		if (r){
		    $.cm({
			    ClassName : "web.DHCUserFavItemPrice",
			    MethodName : "Delete",
			    ARCOSRowidPrice:ARCOSRowidPrice,
			    dataType:'text'
			},function(ret){
				if (ret==0){ 
					$.messager.popover({msg: '删除成功!',type:'success',timeout: 1000});
					PageLogicObj.m_PriceTabDataGrid.datagrid('unselectAll');
					PriceTabDataGridLoad();
					clearSelData();
				}else{
					$.messager.alert("提示",ret);
				}
			})
		}
	});
}
function getComValue(Item){
	var newValue="";
	var value=$("#"+Item).combobox('getValue');
	if (value!=""){
		var data=$("#"+Item).combobox('getData');
		for (var i=0;i<data.length;i++){
			var id=data[i]['id'];
			if (value==id){
				newValue=id.split("^")[0];
				break;
			}
		}
	}
	return newValue;
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
        e.preventDefault();   
    }   
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (ServerObj.sysDateFormat=="3") return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (ServerObj.sysDateFormat=="4") return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(ServerObj.sysDateFormat=="4"){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}