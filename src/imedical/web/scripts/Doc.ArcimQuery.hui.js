var PageLogicObj={
	m_ArcimTabDataGrid:"",
	m_selCatRowId:"",
	m_selSubCatRowId:""
};
$(function(){
	//初始化
	Init();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function Init(){
	PageLogicObj.m_ArcimTabDataGrid=InitArcimTabDataGrid();
	if (window.name=="UDHCJFArcimPrice1"){
		$("#title-panel").panel('setTitle','医嘱字典库录入');
	}
}
/*
ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,lj,DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,tjob
*/
function InitArcimTabDataGrid(){
	var Columns=[[ 
		{field:'id',title:'',hidden:true},
		
		{field:'isARCOS',title:'是否医嘱套',width:80},
		{field:'OrdAlias1',title:'别名',width:200},
		{field:'ordprice2',title:'价格',width:100,align:'right'},
		{field:'lj',title:'链接',width:100,
			formatter: function(value,row,index){
				if (row['id'].indexOf("||")>=0){ 
					var btn = '<a class="editcls" onclick="PriceDetail(\'' + row["id"] + '\')">'+$g("收费明细")+'</a>';
				}else{
					var btn = '<a class="editcls" onclick="ARCOSDetail(\'' + row["id"] + '\')">'+$g("医嘱套明细")+'</a>';
				}
				return btn;
			}
		},
		{field:'DrgGdesc',title:'处方通用名',width:180},
		{field:'ordcode',title:'代码',width:150},
		{field:'ordExternalCode',title:'外部代码',width:120},
		{field:'ordExternalDesc',title:'外部名称',width:120}
    ]]
	var ArcimTabDataGrid=$("#ArcimTab").datagrid({
		fit : true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		pagination : true,  
		pageSize: 15,
		pageList : [15,100,200],
		frozenColumns:[[
			{field:'ordtype2',title:'大类',width:80},
			{field:'ordchildtype',title:'子类',width:100},
			{field:'ordname2',title:'名称',width:200}
		]],
		idField:'id',
		columns :Columns,
		onDblClickRow:function(index, row){
			onDblClickRow(row);
		}
	});
	ArcimTabDataGrid.datagrid('loadData', {"total":0,"rows":[]});
	return ArcimTabDataGrid;
}
function InitEvent(){
	$('#BFind').click(ArcimTabDataGridLoad);
	$('#BAddAlias').click(AddAliasClickHandle);
	$('#BPrint').click(PrintClickHandle);
	$("#Alias").keydown(AliasKeydown);
	$("#Desc").keydown(DescKeydown);
	document.onkeydown=Doc_OnKeyDown;
}
function AliasKeydown(e){
	var key=websys_getKey(e);
	if (key==13) {
		ArcimTabDataGridLoad()
	}
	}
function DescKeydown(e){
	var key=websys_getKey(e);
	if (key==13) {
		ArcimTabDataGridLoad()
	}
	}
function Doc_OnKeyDown(e){
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
function PageHandle(){
	InitCategory();
	InitSubCategory();
	InitOrderStatus();
}
function InitCategory(){
	$("#Category").lookup({
	    url:$URL,
	    mode:'remote',
	    method:"Get",
	    idField:'id',
	    textField:'text',
	    columns:[[  
	        {field:'id',title:'',hidden:true},
			{field:'text',title:'大类名称',width:350}
	    ]], 
	    pagination:true,
	    panelWidth:400,
	    panelHeight:400,
	    isCombo:true,
	    minQueryLen:2,
	    delay:'500',
	    queryOnSameQueryString:false,
	    queryParams:{ClassName: 'web.UDHCJFIntBill',QueryName: 'ordcatlookup'},
	    onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{desc:desc});
	    },
	    onSelect:function(index, rec){
		    PageLogicObj.m_selCatRowId=rec['id'];
		    PageLogicObj.m_selSubCatRowId="";
		    $("#SubCategory").lookup('setText','');
		}
	});
}
function InitSubCategory(){
	$("#SubCategory").lookup({
	    url:$URL,
	    mode:'remote',
	    method:"Get",
	    idField:'id',
	    textField:'text',
	    columns:[[  
	        {field:'id',title:'',hidden:true},
			{field:'text',title:'子类名称',width:350}
	    ]], 
	    pagination:true,
	    panelWidth:400,
	    panelHeight:400,
	    isCombo:true,
	    minQueryLen:2,
	    delay:'500',
	    queryOnSameQueryString:true,
	    queryParams:{ClassName: 'web.UDHCJFIntBill',QueryName: 'ordsubcatlookup'},
	    onBeforeLoad:function(param){
	        var desc=param['q']; 
	        var catDesc=$("#Category").lookup('getText');
	        if (catDesc==""){PageLogicObj.m_selCatRowId=""};
			param = $.extend(param,{ordCatId:PageLogicObj.m_selCatRowId,desc:desc,OrdType:catDesc});
	    },
	    onSelect:function(index, rec){
		    PageLogicObj.m_selSubCatRowId=rec['id'];
		}
	});
}
function InitOrderStatus(){
	$HUI.combobox("#OrderStatus", {
		valueField: 'id',
		textField: 'text', 
		editable:false,
		data: [{"id":"0","text":"全部",'selected':true},{"id":"1","text":"可用"},{"id":"2","text":"不可用"}],
		onSelect:function(rec){
			
		}
	 });
}
function ArcimTabDataGridLoad(){
	var type="";
	if ($("#ARCOS").checkbox('getValue')){
		type="ARCOS";
	}
	if ($("#ARCIM").checkbox('getValue')){
		type="ARCIM";
	}
	if(($("#ARCOS").checkbox('getValue'))&&($("#ARCIM").checkbox('getValue'))){
		type="All";
	}
	$.q({
	    ClassName : "web.UDHCJFOrdPriceSearch1",
	    QueryName : "FindOrdForHUI",
	    Cat:$("#Category").lookup('getText'),
	    SubCat:$("#SubCategory").lookup('getText'),
	    OrderStatus:$("#OrderStatus").combobox('getValue'),
	    Alias:$("#Alias").val(),
	    Desc:$("#Desc").val(),
	    type:type,
	    Pagerows:PageLogicObj.m_ArcimTabDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		PageLogicObj.m_ArcimTabDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
	}); 
}
function AddAliasClickHandle(){
	var row=PageLogicObj.m_ArcimTabDataGrid.datagrid('getSelected');
	if (!row){
		$.messager.alert("提示","请选中要添加别名的医嘱项或医嘱套!");
		return false;
	}
	var index=PageLogicObj.m_ArcimTabDataGrid.datagrid('getRowIndex',row);
	var id=row['id'];
	var OrdAlias1=row['OrdAlias1'];
	var Alias=$("#Alias").val();
	if (Alias==""){
		$.messager.alert("提示","别名不能为空","info",function(){
			$("#Alias").focus();
		});
		return false;
	}
	if (id.indexOf("||")>=0){
		$.cm({
			ClassName:"web.DHCBL.CT.ARCAlias",
			MethodName:"AddOrderAlias",
		    SaveDataStr:id+"^"+Alias
		},function(ret){
			if (ret.info=="保存成功"){
				PageLogicObj.m_ArcimTabDataGrid.datagrid('updateRow',{
					index: index,
					row: {
						OrdAlias1: OrdAlias1+"/"+Alias.toUpperCase()
					}
				});
			}
			$.messager.alert("提示",ret.info);
		});
	}else{
		$.cm({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"InsertARCAlias",
		    AliasType :"ARCOS",
		    Rowid:id,
		    Alias:Alias,
		    dateType:"text"
		},function(ret){
			if (ret>0){
				$.messager.alert("提示","保存成功!","info",function(){
					PageLogicObj.m_ArcimTabDataGrid.datagrid('updateRow',{
						index: index,
						row: {
							OrdAlias1: OrdAlias1+"/"+Alias.toUpperCase()
						}
					});
				});
			}else{
				$.messager.alert("提示","保存失败!");
			}
		});
	}
}
function PrintClickHandle(){
	var xlApp,obook,osheet,xlsheet,xlBook,temp,str,vbdata,i,j
    var Template
    var k=0,l
    var path=$.cm({
		ClassName:"web.UDHCJFOrdPriceSearch1",
		MethodName:"getpath",
	    dateType:"text"
	})
	Template=path+"UDHCJFArcimPrice.xls";
	var rows=PageLogicObj.m_ArcimTabDataGrid.datagrid('getRows');
	if (rows.length==0){
		$.messager.alert("提示","无打印数据!");
	    return false;
	}
	xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet  
    xlApp.visible=true;
	var row=1
	var p1=jj
	xlsheet.cells(1,1)="医嘱名称"
	xlsheet.cells(1,2)="医嘱别名"
	xlsheet.cells(1,3)="医嘱价格"
	xlsheet.cells(1,4)="收费代码"
	xlsheet.cells(1,5)="收费名称"
	xlsheet.cells(1,6)="数量"
	xlsheet.cells(1,7)="价格"
	if(CheckExternalCode.checked == true){
		  xlsheet.cells(1,8)="LIS代码"
	      xlsheet.cells(1,9)="组套名" 
	}
	var gnum=cspRunServerMethod(encmeth,'','',p1);
    for (i=1;i<=gnum;i++){    
    	p3=i	          
         var getdata=document.getElementById('getdata');
         if (getdata) {var encmeth=getdata.value} else {var encmeth=''};
         var str=cspRunServerMethod(encmeth,'','',p1,p3);
         myData1=str.split("^")    
         xlsheet.cells(i+1,1)=myData1[1]
         xlsheet.cells(i+1,2)=myData1[9]
         xlsheet.cells(i+1,3)=myData1[3]
         xlsheet.cells(i+1,4)=myData1[11]
         xlsheet.cells(i+1,5)=myData1[5]
         xlsheet.cells(i+1,6)=myData1[6]
         xlsheet.cells(i+1,7)=myData1[7]
         xlsheet.cells(i+1,8)=myData1[12]
         xlsheet.cells(i+1,9)=myData1[13]
     }	       
}
function PriceDetail(ARCIMRowId){
	var $code='<div style="border:1px solid #ccc;margin:10px;border-radius:4px;"><table id="OrderPriceGrid"></table></div>'
	createModalDialog("Grid","收费明细", 1005, 520,"icon-w-list","",$code,"LoadOrderPriceGrid('"+ARCIMRowId+"')");
}
function ARCOSDetail(ARCOSRowId){
	var $code='<div style="border:1px solid #ccc;margin:10px;border-radius:4px;"><table id="ARCOSDetailGrid"></table></div>'
	createModalDialog("Grid","医嘱套明细", 1005, 520,"icon-w-list","",$code,"LoadARCOSDetailGrid('"+ARCOSRowId+"')")
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    },
	    onBeforeOpen:function(){
		    if (_event!="") eval(_event);
		    return true;
		}
    });
}
function LoadARCOSDetailGrid(ARCOSRowid){
	var Columns=[[    
			{field:'NO',title:'序号',width:50},
			{field:'ARCIMDesc',title:'名称',width:300,align:'left'}, 
			{field:'ARCOSItemDoseQty',title:'剂量',width:50},
			{field:'ARCOSItemUOM',title:'剂量单位',width:100},
			{field:'ARCOSItemFrequence',title:'频次',width:50},
			{field:'ARCOSItemInstruction',title:'用法',width:100},
			{field:'ARCOSItemDuration',title:'疗程',width:50},  
			{field:'ARCOSItemQty',title:'数量',width:60},   
			{field:'ARCOSItemBillUOM',title:'单位',width:50},
			{field:'ARCOSItmLinkDoctor',title:'关联',width:50},
			{field:'Tremark',title:'备注',width:150},
			{field:'ARCOSDHCDocOrderType',title:'医嘱类型',width:100},
			{field:'SampleDesc',title:'标本',width:100},
			{field:'OrderPriorRemarks',title:'附加说明',width:100},
			{field:'DHCDocOrdRecLoc',title:'接收科室',width:200},
			{field:'DHCDocOrdStage',title:'医嘱阶段',width:150},
			{field:'DHCMustEnter',title:'必开项',width:80},
			{field:'SpeedFlowRate',title:'输液流速',width:80},
			{field:'FlowRateUnit',title:'流速单位',width:85}
	    ]];
		$.q({
		    ClassName:"web.DHCARCOrdSets",
		    QueryName:"FindOSItem",
		    ARCOSRowid:ARCOSRowid, QueryFlag:"1",
		},function(GridData){
			$HUI.datagrid('#ARCOSDetailGrid',{
			    data:GridData,
			    idField:'olttariffdr',
			    fit : false,
			    width:970,
			    height:460,
			    border: false,
			    columns:Columns
			});
		});  
}
function LoadOrderPriceGrid(ARCIMRowId){
	var Columns=[[    
		{field:'olttariffdr', hidden:true},
        {title:'收费项目代码',field:'tarcode',width:130},
        {title:'收费项目名称',field:'tardesc',width:180},
        {title:'数量',field:'tarnum', width:40},
        {title:'单位',field:'taruom', width:100},
        {title:'开始日期',field:'tarDate',width:100},
        {title:'结束日期',field:'tarDateTo', width:100},
        {title:'基价模式',field:'OLTBascPriceFlag',width:100},
        {title:'多部位计价一次',field:'OLTBillOnceFlag', width:120},
        {title:'价格',field:'tarprice',width:80,align:'right'}
    ]];
	$.q({
	    ClassName:"web.UDHCJFOrdPriceSearch1",
	    QueryName:"QueryArcimLinkTar",
	    arcimrowid:ARCIMRowId
	},function(GridData){
		$HUI.datagrid('#OrderPriceGrid',{
		    data:GridData,
		    idField:'olttariffdr',
		    fit : false,
		    width:970,
		    height:460,
		    border: false,
		    columns:Columns,
		    rowStyler: function(index,row){
			    if (row.tarnum==""){
					return 'background-color:#6293BB;color:#fff;';
				}
		    }
		});
	});  
}
function destroyDialog(id){
   //移除存在的Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function onDblClickRow(row){
	var id=row['id'];
	if (id.indexOf("||")>=0){
		var UserGroupID=session['LOGON.GROUPID'];
		var ret=$.cm({
		    ClassName : "web.DHCDocOrderEntry",
		    QueryName : "AddControl",
		    ACRIM:id, GroupID:UserGroupID,
		    dataType:"text"
		},false)
	    if (ret==1){
			$.messager.alert("提示","无权限!");
			return false;
		}
	}/*else{
		websys_showModal('options').OSItemListOpen(id, "", "YES", "", "");
	}*/
	websys_showModal("hide");
	websys_showModal('options').PACSArcimFun(id);
	//websys_showModal("close");
	return false;
}
