var PageLogicObj={
	m_selTreeId:""
};
$(function(){
	Init();
	//事件初始化
	InitEvent();
});
function Init(){
	InitProductLine();
	InitConfigFindTab();
	LoadUnRegisterConfigItem();
}
function InitEvent(){
	$('#Import').click(ImportHandler);
	$('#BFind').click(FindClickHandler);
	$('#BSaveConfigRemark').click(SaveConfigRemark);
}
function FindClickHandler(){
	LoadTreeGridData();
}
function ImportHandler(){
	var fileObj = $("#TemplateExcel").filebox("files");
	var fileObj2 = $("#TemplateExcel").filebox("options");
	if (fileObj.length == 0) {
		$.messager.alert("提示", "请选择模版!", 'info');
		return
	}
	var fileType = fileObj[0].type;
	if ((fileType != "application/vnd.ms-excel")&&(fileType != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) {
		$.messager.alert("提示", "请选择.xls或.xlsx格式的模版!", 'info');
		$("#TemplateExcel").filebox("clear");
		return
	}
	var fileName = $("#filebox_file_id_1").val();
	if (fileName == ""){
		fileName = fileObj[0].name;
	}
	//创建操作EXCEL应用程序的实例
	var oXL = new ActiveXObject("Excel.application");  
	//打开指定路径的excel文件
    var oWB = oXL.Workbooks.open(fileName);  
    //操作第一个sheet(从一开始，而非零)  
    oWB.worksheets(1).select();  
    var oSheet = oWB.ActiveSheet;  
    //使用的行数  
    var rows =  oSheet.usedrange.rows.count
    var ret=1;

    var tempStr=""
    var Spl=String.fromCharCode(2)
    try {  
         for (var i = 2; i <= rows; i++) {
	        /* 直接导入  ImportDocConfigXls
	        	产品线 主页面csp 主页面名称 元素所在页csp 元素所在页名称 元素所在单元ID 元素所在单元描述 元素ID 元素名称 元素说明 链接csp
	        var productLine=oSheet.Cells(i, 1).value==undefined?"":oSheet.Cells(i,1).value;
			var mainCSPCode=oSheet.Cells(i, 2).value==undefined?"":oSheet.Cells(i,2).value;
			var mainCSPName=oSheet.Cells(i, 3).value==undefined?"":oSheet.Cells(i,3).value;
			var itemCSPCode=oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value;
			var itemCSPName=oSheet.Cells(i, 5).value==undefined?"":oSheet.Cells(i,5).value;
			var itemUnitCode=oSheet.Cells(i, 6).value==undefined?"":oSheet.Cells(i,6).value;
			var itemUnitName=oSheet.Cells(i, 7).value==undefined?"":oSheet.Cells(i,7).value;
			var itemID=oSheet.Cells(i, 8).value==undefined?"":oSheet.Cells(i,8).value;
			var itemName=oSheet.Cells(i, 9).value==undefined?"":oSheet.Cells(i,9).value;
			var itemRemarks=oSheet.Cells(i, 10).value==undefined?"":oSheet.Cells(i,10).value;
			var mainCSPIsLink=oSheet.Cells(i, 11).value==undefined?"":oSheet.Cells(i,11).value;
			var onetempStr=productLine+Spl+mainCSPCode+Spl+mainCSPName+Spl+itemCSPCode+Spl+itemCSPName+Spl+itemUnitCode;
			onetempStr=onetempStr+Spl+itemUnitName+Spl+itemID+Spl+itemName+Spl+itemRemarks+Spl+linkCSPCode;
			*/
			
			/* 先缓存页面后导入 ImportDocConfigXls2*/
			var itemCSPCode=oSheet.Cells(i, 2).value==undefined?"":oSheet.Cells(i,2).value;
			var itemName=oSheet.Cells(i, 3).value==undefined?"":oSheet.Cells(i,3).value;
			var itemRemarks=oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value;
			var onetempStr=itemCSPCode+Spl+itemName+Spl+itemRemarks;
			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
			//太多了 一行一行导入
			$.cm({
			    ClassName:"web.DHCDocConfigFind",
			    MethodName:"ImportDocConfigXls2",
			    Data:onetempStr,
			    dataType:"text"
			},false)
         }  
    } catch(e) {  
    	$.messager.alert("提示", e.messager, 'info');
    }  
    
	/*if (tempStr!=""){
		$.cm({
		    ClassName:"web.DHCDocConfigFind",
		    MethodName:"ImportDocConfigXls2",
		    Data:tempStr,
		    dataType:"text"
		},function(ret){
			//退出操作excel的实例对象  
			oXL.Application.Quit();  
			$.messager.alert("提示", "导入成功"+ret+"条数据!", 'info');
			$("#TemplateExcel").filebox("clear");
		})
		//ret=tkMakeServerCall("web.DHCDocConfigFind","ImportDocConfigXls2",tempStr);
	}*/
}
function InitConfigFindTab(){
	var toolbar=[{
        text: '登记配置点',
        iconCls: 'icon-add',
        handler: function() {
	        PageLogicObj.m_selTreeId="";
	        clearConfigSetWin();
	        $(".textbox").prop("disabled",false);
	        $('#ConfigSetWin').dialog("open");
	    }
    },{
        text: '登记页面',
        iconCls: 'icon-add',
        handler: function() {
	        PageLogicObj.m_selTreeId="";
	        clearConfigSetWin();
	        $(".textbox").prop("disabled",false);
	        $('#itemUnitCode,#itemUnitName,#ItemName,#ItemId').val("").prop("disabled",true);
	        $('#ConfigSetWin').dialog("open");
	    }
    },{
        text: '修改',
        iconCls: 'icon-edit',
        handler: function() {UpdateClickHandle();}
    },'-',{
	    id:'UnRegisterConfigItem',
        text: '未登记的配置数',
        iconCls: 'icon-alert-red',
        handler: function() {
	        $('#UnRegisterConfigItemWin').dialog("open");
	        LoadUnRegisterConfigItemGridData();
        }
    },'-',{
	    id:'tip',
        text: '使用说明',
        iconCls: 'icon-help',
        handler: function() {
	       $("#tip").popover('show');
        }
    }];
	var Columns=[[
        {title:'配置点描述',field:'name',width:320,
        	formatter:function(value,row,index){
	        	if (row.IsLink == "Y") {
		    		var btn = '<a style="text-decoration: underline;cursor:pointer;" onclick="OpenConfigWin(\''+row.LinkCSPCode +'\',\''+value +'\')">'+value+'\</a>';
		    		return btn;
		        }else{
			        return value;
			    }
	    	}
        },
        //{title:'主页面csp',field:'mainCSPCode',width:180},        
        //{title:'元素所在页名称',field:'itemCSPName',width:180},
        //{title:'元素所在单元csp',field:'itemUnitCode',width:180},
        //{title:'元素所在单元名称',field:'itemUnitName',width:180},
        {title:'配置点说明或作用',field:'itemRemarks',
        	formatter:function(value,row,index){
	        	if(row.itemID==""){
		        	return row.itemCSPRemarks;
		        }else{
			        return value;
			    }
	        }
        },
        //{title:'配置点主页面名称',field:'mainCSPName',width:180},
        //{title:'元素所在页csp',field:'itemCSPCode',width:180}
    ]];
    $HUI.treegrid('#ConfigFindTab',{
	    idField:'index',
	    treeField:'name',
	    headerCls:'panel-header-gray',
	    fit : true,
	    border: false,   
	    columns:Columns,
	    toolbar:toolbar,
		onDblClickRow:function(index){
			var node=$('#ConfigFindTab').treegrid('getSelected');
			var child=$('#ConfigFindTab').treegrid('getChildren',node.index);
			if (child.length == 0) {
				UpdateClickHandle();
			}
		}
	});
	LoadTreeGridData();
	InitTip();
}
function OpenConfigWin(url,title){
	websys_showModal({
		url:url,
		title:title,
		width:'90%',height:'90%'
	});
}
function InitProductLine(){
	$HUI.combobox("#searchProductLine", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
		valueField:'code',
		textField:'name',
		rowStyle:'checkbox', //显示成勾选行形式
		multiple:true,
		editable:false
	});
	$HUI.combobox("#ProductLine", {
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
		valueField:'code',
		textField:'name',
		editable:false
	});
}
function LoadTreeGridData(){
	var searchProductLineArr=$("#searchProductLine").combobox('getValues');
	var searchProductLines="";
	for (var i=0;i<searchProductLineArr.length;i++){
		if (searchProductLines=="") searchProductLines = searchProductLineArr[i];
		else  searchProductLines = searchProductLines=searchProductLines+"#"+searchProductLineArr[i];
	}
	var searchPageCSP=$("#searchPageCSP").val().replace(/\ /g,"");
	var searchPageCSPName=$("#searchPageCSPName").val().replace(/\ /g,"");
	var searchItemName=$("#searchItemName").val().replace(/\ /g,"");
	$.cm({
	    ClassName:"web.DHCDocConfigFind",
	    MethodName:"DHCDocConfigFind",
	    searchProductLines:searchProductLines,
	    searchPageCSP:searchPageCSP,
	    searchPageCSPName:searchPageCSPName,
	    searchItemName:searchItemName
	},function(GridData){
		$('#ConfigFindTab').treegrid('unselectAll').treegrid('loadData',GridData);
	})
}
function clearConfigSetWin(){
	$("#ProductLine").combobox('select','');
	$("#ConfigSetWin .textbox").val('');
	$("#mainCSPIsLink").checkbox('setValue',false);
}
function SaveConfigRemark(){
	var ProductLine=$("#ProductLine").combobox('getValue');
	if (!ProductLine) {
		$.messager.alert("提示", "请选择产品线!");
		return;
	}
	var MainPageCSPCode=$("#MainPageCSPCode").val().replace(/\ /g,"");
	var MainPageCSPName=$("#MainPageCSPName").val().replace(/\ /g,"");
	var mainCSPIsLink=$("#mainCSPIsLink").checkbox('getValue')?"Y":"N";
	if (mainCSPIsLink == "Y") {
		if (!MainPageCSPCode) {
			$.messager.alert("提示", "按主页面链接配置勾选时主页面CSP不能为空!","info",function(){
				$("#MainPageCSPCode").focus();
			});
			return;
		}
		if (!MainPageCSPName) {
			$.messager.alert("提示", "按主页面链接配置勾选时主页面名称为空!","info",function(){
				$("#MainPageCSPName").focus();
			});
			return;
		}
	}
	var itemUnitCode=$("#itemUnitCode").val().replace(/\ /g,"");
	var itemUnitName=$("#itemUnitName").val().replace(/\ /g,"");
	var PageCSPCode=$("#PageCSPCode").val().replace(/\ /g,"");
	if (!PageCSPCode) {
		$.messager.alert("提示", "请填写配置点页面CSP!","info",function(){
			$("#PageCSPCode").focus();
		});
		return;
	}
	var PageCSPName=$("#PageCSPName").val().replace(/\ /g,"");
	if (!PageCSPName) {
		$.messager.alert("提示", "请填写配置点页面名称!","info",function(){
			$("#PageCSPName").focus();
		});
		return;
	}
	var ItemId=$("#ItemId").val().replace(/\ /g,"");
	if ((!ItemId)&&(!$("#ItemId").prop("disabled"))) {
		$.messager.alert("提示", "请填写配置点元素ID!","info",function(){
			$("#ItemId").focus();
		});
		return;
	}
	var ItemName=$("#ItemName").val().replace(/\ /g,"");
	if ((!ItemName)&&(!$("#ItemName").prop("disabled"))) {
		$.messager.alert("提示", "请填写配置点元素描述!","info",function(){
			$("#ItemName").focus();
		});
		return;
	}
	var ItemRemarks=$("#ItemRemarks").val().replace(/\ /g,"");
	var Spl=String.fromCharCode(1);
	var Str=PageLogicObj.m_selTreeId+Spl+ProductLine+Spl+MainPageCSPCode+Spl+MainPageCSPName+Spl+mainCSPIsLink;
	Str=Str+Spl+itemUnitCode+Spl+itemUnitName+Spl+PageCSPCode+Spl+PageCSPName;
	Str=Str+Spl+ItemId+Spl+ItemName+Spl+ItemRemarks;
	$.cm({
	    ClassName:"web.DHCDocConfigFind",
	    MethodName:"SaveDocConfigRemark",
	    Str:Str,
	    dataType:"text"
	},function(rtn){
		if (rtn=="repeat") {
			$.messager.alert("提示", "该配置点页面已存在该元素!","info",function(){
				$("#ItemId").focus();
			});
		}else if (rtn < 0) {
			$.messager.alert("提示", "保存失败！"+rtn);
		}else{
			PageLogicObj.m_selTreeId="";
			$('#ConfigSetWin').dialog("close");
			LoadTreeGridData();
		}
	})
}
function UpdateClickHandle(){
	var node=$('#ConfigFindTab').treegrid('getSelected');
	if (!node){
		$.messager.alert("提示", "请选择修改的配置点!");
		return;
	}
	var child=$('#ConfigFindTab').treegrid('getChildren',node.index);
	if (child.length > 0) {
		$.messager.alert("提示", "请选择最小配置点!");
		return;
	}
	PageLogicObj.m_selTreeId=node.rowid;
	$('#ProductLine').combobox('select',node.productLine);
	$('#MainPageCSPCode').val(node.mainCSPCode);
	$('#MainPageCSPName').val(node.mainCSPName);
	$('#mainCSPIsLink').checkbox('setValue',node.mainCSPIsLink=="N"?false:true);
	$(".textbox").prop("disabled",false);
	if (node.itemID=="") {
		$('#PageCSPCode').val(node.itemCSPCode);
		$('#PageCSPName').val(node.itemCSPName);
		$('#itemUnitCode,#itemUnitName,#ItemName,#ItemId').val("").prop("disabled",true);
		$('#ItemRemarks').val(node.itemCSPRemarks);
	}else{
		$('#itemUnitCode').val(node.itemUnitCode);
		$('#itemUnitName').val(node.itemUnitName);
		$('#PageCSPCode').val(node.itemCSPCode);
		$('#PageCSPName').val(node.itemCSPName);
		$('#ItemName').val(node.name);
		$('#ItemId').val(node.itemID);
		$('#ItemRemarks').val(node.itemRemarks);
	}
	$('#ConfigSetWin').dialog("open");
}
function LoadUnRegisterConfigItem(){
	$.cm({
	    ClassName:"web.DHCDocConfigFind",
	    MethodName:"GetUnRegisterConfigItem"
	},function(GridData){
		var count=GridData[0].count;
		var _$btn=$("#UnRegisterConfigItem .l-btn-text")[0];
		_$btn.innerText="未登记的配置数"+"("+count+")"
	})
}
function LoadUnRegisterConfigItemGridData(){
	var toolbar=[{
        text: '确认登记',
        iconCls: 'icon-ok',
        handler: function() {
	        SaveUnRegisterConfigItem();
	    }
    }];
	var Columns=[[
        {title:'配置点描述',field:'name',width:320},
        {title:'配置点说明或作用',field:'itemRemarks',width:400,
        	editor : {type : 'text',options : {}}
        },
    ]];
	$.cm({
	    ClassName:"web.DHCDocConfigFind",
	    MethodName:"GetUnRegisterConfigItem"
	},function(GridData){
		$HUI.treegrid('#UnRegisterConfigItemTab',{
			height:'460',
			data:GridData[0].data,
			checkbox:true,
		    idField:'index',
		    treeField:'name',
		    headerCls:'panel-header-gray',
		    fit : false,
		    border: false,   
		    columns:Columns,
		    toolbar:toolbar,
			onClickCell:function(field,row){
				if (field=="itemRemarks") {
					var child=$('#ConfigFindTab').treegrid('getChildren',row.index);
					if (child.length == 0) {
						$('#UnRegisterConfigItemTab').datagrid('beginEdit',row.index);
					}
				}
			}
		});
	})
}
function SaveUnRegisterConfigItem(){
	var nodes=$('#UnRegisterConfigItemTab').treegrid('getCheckedNodes','checked');
	if (nodes.length == 0) {
		$.messager.alert("提示", "请勾选需要登记的配置!");
		return;
	}
	nodes=nodes.sort(compare('index'));
	var Spl=String.fromCharCode(1);
	var RegisterConfigArr=[];
	for (var i=0;i<nodes.length;i++){
		$('#UnRegisterConfigItemTab').datagrid('endEdit',nodes[i].index);
		var child=$('#UnRegisterConfigItemTab').treegrid('getChildren',nodes[i].index);
		if (child.length == 0) {
			var oneStr=""+Spl+nodes[i].DOPProductLine+Spl+nodes[i].DOPMainCSPCode+Spl+nodes[i].DOPMainCSPDesc;
			oneStr=oneStr+Spl+nodes[i].DOPMainCSPIsLink+Spl+nodes[i].PDDomUnitID+Spl+nodes[i].PDDomUnitName;
			oneStr=oneStr+Spl+nodes[i].DOPCode+Spl+nodes[i].DOPDesc+Spl+nodes[i].PDDomID+Spl+nodes[i].PDDomName;
			oneStr=oneStr+Spl+nodes[i].itemRemarks;
			RegisterConfigArr.push(oneStr);
		}
	}
	var RegisterConfigStr=RegisterConfigArr.join(String.fromCharCode(2));
	$.cm({
	    ClassName:"web.DHCDocConfigFind",
	    MethodName:"SaveUnRegisterConfigItem",
	    Str:RegisterConfigStr,
	    dataType:"text"
	},function(rtn){
		if (rtn < 0) {
			$.messager.alert("提示", "保存失败！"+rtn);
		}else{
			$('#UnRegisterConfigItemTab').datagrid('unselectAll');
			$('#UnRegisterConfigItemWin').dialog("close");
			LoadTreeGridData();
			LoadUnRegisterConfigItem();
		}
	})
}
function compare(property){
    return function(a,b){
        var value1 = a[property];
        var value2 = b[property];
        return value1 - value2;
    }
}
function InitTip(){
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>医生站应用配置速查使用说明</li>" + 
		'<li>1、该页面是用来快速查询医生站相关配置点说明或作用，亦可新增或修改已登记配置说明。</li>' +
		'<li>2、"未登记的配置数"是指已进行页面缓存但未在本页面登记的配置，点击后可在弹出框维护配置点备注并进行批量登记。</li>' +
		'<li>一：需要缓存的配置页面使用说明</li>' +
		'<li>1、CSP增加引用 /dhcdoc/tools/pageDom.js'+
		'<li>2、CSP增加全局请求后台服务对象ServerObj={}，例如注册配置页面:var ServerObj={ </li>'+
			'<li>pageCode:"reg.cardpatconfig.hui.csp", //页面csp名'+
			'<li>pageName:"注册配置", //页面功能名称</li>'+
			'<li>ProductLine:"Reg", //产品线,详细代码详见"本地化参数设置"配置说明</li>'+
			'<li>parentPageCode:"", //主页面csp名,用以记录缓存页面的父页面</li>'+
			'<li>parentPageName:"",//主页面功能名称</li>'+
			'<li>MainCSPIsLink:"N", //按主页面链接配置Y/N，Y:点击父页面名称弹出配置页面的父页面(适用于子页面与父页面有交互,不能直接弹出子页面),N:点击页面名称弹出配置页面</li>'+
			'<li>domSelectors:".textbox^.hisui-switchbox^#CardRegDOMTab!table!0" //需要缓存元素的选择器，多个选择器以^分割。表格选择器格式为：表格ID!table!flag(flag:0 不缓存表格列，1：缓存表格列)</li>'+
			'<li>domNotSelectors:"".datebox^#SearchCode" //需要过滤缓存的元素选择器，多个选择器以^分割</li>'+
		'};' +
		'<li>3、缓存页面调用 $.DHCDoc.CacheConfigPage();判断页面是否已缓存,1:已缓存 0:未缓存。 </li>'+
		'<li>4、缓存页面调用 $.DHCDoc.storageConfigPageCache();用来缓存页面设置点。 </li>'+
		'<li>5、缓存csp表：DHC_DocOrderPage，缓存页面DOM表：DHC_DocPageDom </li>'+
		"</ul>" 
	$("#tip").popover({
		width:800,
		trigger:'hover',
		content:_content
	});
}