var PageLogicObj={
	m_selTreeId:""
};
$(function(){
	Init();
	//�¼���ʼ��
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
		$.messager.alert("��ʾ", "��ѡ��ģ��!", 'info');
		return
	}
	var fileType = fileObj[0].type;
	if ((fileType != "application/vnd.ms-excel")&&(fileType != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")) {
		$.messager.alert("��ʾ", "��ѡ��.xls��.xlsx��ʽ��ģ��!", 'info');
		$("#TemplateExcel").filebox("clear");
		return
	}
	var fileName = $("#filebox_file_id_1").val();
	if (fileName == ""){
		fileName = fileObj[0].name;
	}
	//��������EXCELӦ�ó����ʵ��
	var oXL = new ActiveXObject("Excel.application");  
	//��ָ��·����excel�ļ�
    var oWB = oXL.Workbooks.open(fileName);  
    //������һ��sheet(��һ��ʼ��������)  
    oWB.worksheets(1).select();  
    var oSheet = oWB.ActiveSheet;  
    //ʹ�õ�����  
    var rows =  oSheet.usedrange.rows.count
    var ret=1;

    var tempStr=""
    var Spl=String.fromCharCode(2)
    try {  
         for (var i = 2; i <= rows; i++) {
	        /* ֱ�ӵ���  ImportDocConfigXls
	        	��Ʒ�� ��ҳ��csp ��ҳ������ Ԫ������ҳcsp Ԫ������ҳ���� Ԫ�����ڵ�ԪID Ԫ�����ڵ�Ԫ���� Ԫ��ID Ԫ������ Ԫ��˵�� ����csp
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
			
			/* �Ȼ���ҳ����� ImportDocConfigXls2*/
			var itemCSPCode=oSheet.Cells(i, 2).value==undefined?"":oSheet.Cells(i,2).value;
			var itemName=oSheet.Cells(i, 3).value==undefined?"":oSheet.Cells(i,3).value;
			var itemRemarks=oSheet.Cells(i, 4).value==undefined?"":oSheet.Cells(i,4).value;
			var onetempStr=itemCSPCode+Spl+itemName+Spl+itemRemarks;
			if (tempStr=="") tempStr=onetempStr
			else tempStr=tempStr+String.fromCharCode(1)+onetempStr
			//̫���� һ��һ�е���
			$.cm({
			    ClassName:"web.DHCDocConfigFind",
			    MethodName:"ImportDocConfigXls2",
			    Data:onetempStr,
			    dataType:"text"
			},false)
         }  
    } catch(e) {  
    	$.messager.alert("��ʾ", e.messager, 'info');
    }  
    
	/*if (tempStr!=""){
		$.cm({
		    ClassName:"web.DHCDocConfigFind",
		    MethodName:"ImportDocConfigXls2",
		    Data:tempStr,
		    dataType:"text"
		},function(ret){
			//�˳�����excel��ʵ������  
			oXL.Application.Quit();  
			$.messager.alert("��ʾ", "����ɹ�"+ret+"������!", 'info');
			$("#TemplateExcel").filebox("clear");
		})
		//ret=tkMakeServerCall("web.DHCDocConfigFind","ImportDocConfigXls2",tempStr);
	}*/
}
function InitConfigFindTab(){
	var toolbar=[{
        text: '�Ǽ����õ�',
        iconCls: 'icon-add',
        handler: function() {
	        PageLogicObj.m_selTreeId="";
	        clearConfigSetWin();
	        $(".textbox").prop("disabled",false);
	        $('#ConfigSetWin').dialog("open");
	    }
    },{
        text: '�Ǽ�ҳ��',
        iconCls: 'icon-add',
        handler: function() {
	        PageLogicObj.m_selTreeId="";
	        clearConfigSetWin();
	        $(".textbox").prop("disabled",false);
	        $('#itemUnitCode,#itemUnitName,#ItemName,#ItemId').val("").prop("disabled",true);
	        $('#ConfigSetWin').dialog("open");
	    }
    },{
        text: '�޸�',
        iconCls: 'icon-edit',
        handler: function() {UpdateClickHandle();}
    },'-',{
	    id:'UnRegisterConfigItem',
        text: 'δ�Ǽǵ�������',
        iconCls: 'icon-alert-red',
        handler: function() {
	        $('#UnRegisterConfigItemWin').dialog("open");
	        LoadUnRegisterConfigItemGridData();
        }
    },'-',{
	    id:'tip',
        text: 'ʹ��˵��',
        iconCls: 'icon-help',
        handler: function() {
	       $("#tip").popover('show');
        }
    }];
	var Columns=[[
        {title:'���õ�����',field:'name',width:320,
        	formatter:function(value,row,index){
	        	if (row.IsLink == "Y") {
		    		var btn = '<a style="text-decoration: underline;cursor:pointer;" onclick="OpenConfigWin(\''+row.LinkCSPCode +'\',\''+value +'\')">'+value+'\</a>';
		    		return btn;
		        }else{
			        return value;
			    }
	    	}
        },
        //{title:'��ҳ��csp',field:'mainCSPCode',width:180},        
        //{title:'Ԫ������ҳ����',field:'itemCSPName',width:180},
        //{title:'Ԫ�����ڵ�Ԫcsp',field:'itemUnitCode',width:180},
        //{title:'Ԫ�����ڵ�Ԫ����',field:'itemUnitName',width:180},
        {title:'���õ�˵��������',field:'itemRemarks',
        	formatter:function(value,row,index){
	        	if(row.itemID==""){
		        	return row.itemCSPRemarks;
		        }else{
			        return value;
			    }
	        }
        },
        //{title:'���õ���ҳ������',field:'mainCSPName',width:180},
        //{title:'Ԫ������ҳcsp',field:'itemCSPCode',width:180}
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
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
		$.messager.alert("��ʾ", "��ѡ���Ʒ��!");
		return;
	}
	var MainPageCSPCode=$("#MainPageCSPCode").val().replace(/\ /g,"");
	var MainPageCSPName=$("#MainPageCSPName").val().replace(/\ /g,"");
	var mainCSPIsLink=$("#mainCSPIsLink").checkbox('getValue')?"Y":"N";
	if (mainCSPIsLink == "Y") {
		if (!MainPageCSPCode) {
			$.messager.alert("��ʾ", "����ҳ���������ù�ѡʱ��ҳ��CSP����Ϊ��!","info",function(){
				$("#MainPageCSPCode").focus();
			});
			return;
		}
		if (!MainPageCSPName) {
			$.messager.alert("��ʾ", "����ҳ���������ù�ѡʱ��ҳ������Ϊ��!","info",function(){
				$("#MainPageCSPName").focus();
			});
			return;
		}
	}
	var itemUnitCode=$("#itemUnitCode").val().replace(/\ /g,"");
	var itemUnitName=$("#itemUnitName").val().replace(/\ /g,"");
	var PageCSPCode=$("#PageCSPCode").val().replace(/\ /g,"");
	if (!PageCSPCode) {
		$.messager.alert("��ʾ", "����д���õ�ҳ��CSP!","info",function(){
			$("#PageCSPCode").focus();
		});
		return;
	}
	var PageCSPName=$("#PageCSPName").val().replace(/\ /g,"");
	if (!PageCSPName) {
		$.messager.alert("��ʾ", "����д���õ�ҳ������!","info",function(){
			$("#PageCSPName").focus();
		});
		return;
	}
	var ItemId=$("#ItemId").val().replace(/\ /g,"");
	if ((!ItemId)&&(!$("#ItemId").prop("disabled"))) {
		$.messager.alert("��ʾ", "����д���õ�Ԫ��ID!","info",function(){
			$("#ItemId").focus();
		});
		return;
	}
	var ItemName=$("#ItemName").val().replace(/\ /g,"");
	if ((!ItemName)&&(!$("#ItemName").prop("disabled"))) {
		$.messager.alert("��ʾ", "����д���õ�Ԫ������!","info",function(){
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
			$.messager.alert("��ʾ", "�����õ�ҳ���Ѵ��ڸ�Ԫ��!","info",function(){
				$("#ItemId").focus();
			});
		}else if (rtn < 0) {
			$.messager.alert("��ʾ", "����ʧ�ܣ�"+rtn);
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
		$.messager.alert("��ʾ", "��ѡ���޸ĵ����õ�!");
		return;
	}
	var child=$('#ConfigFindTab').treegrid('getChildren',node.index);
	if (child.length > 0) {
		$.messager.alert("��ʾ", "��ѡ����С���õ�!");
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
		_$btn.innerText="δ�Ǽǵ�������"+"("+count+")"
	})
}
function LoadUnRegisterConfigItemGridData(){
	var toolbar=[{
        text: 'ȷ�ϵǼ�',
        iconCls: 'icon-ok',
        handler: function() {
	        SaveUnRegisterConfigItem();
	    }
    }];
	var Columns=[[
        {title:'���õ�����',field:'name',width:320},
        {title:'���õ�˵��������',field:'itemRemarks',width:400,
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
		$.messager.alert("��ʾ", "�빴ѡ��Ҫ�Ǽǵ�����!");
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
			$.messager.alert("��ʾ", "����ʧ�ܣ�"+rtn);
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
	var _content = "<ul class='tip_class'><li style='font-weight:bold'>ҽ��վӦ�������ٲ�ʹ��˵��</li>" + 
		'<li>1����ҳ�����������ٲ�ѯҽ��վ������õ�˵�������ã�����������޸��ѵǼ�����˵����</li>' +
		'<li>2��"δ�Ǽǵ�������"��ָ�ѽ���ҳ�滺�浫δ�ڱ�ҳ��Ǽǵ����ã��������ڵ�����ά�����õ㱸ע�����������Ǽǡ�</li>' +
		'<li>һ����Ҫ���������ҳ��ʹ��˵��</li>' +
		'<li>1��CSP�������� /dhcdoc/tools/pageDom.js'+
		'<li>2��CSP����ȫ�������̨�������ServerObj={}������ע������ҳ��:var ServerObj={ </li>'+
			'<li>pageCode:"reg.cardpatconfig.hui.csp", //ҳ��csp��'+
			'<li>pageName:"ע������", //ҳ�湦������</li>'+
			'<li>ProductLine:"Reg", //��Ʒ��,��ϸ�������"���ػ���������"����˵��</li>'+
			'<li>parentPageCode:"", //��ҳ��csp��,���Լ�¼����ҳ��ĸ�ҳ��</li>'+
			'<li>parentPageName:"",//��ҳ�湦������</li>'+
			'<li>MainCSPIsLink:"N", //����ҳ����������Y/N��Y:�����ҳ�����Ƶ�������ҳ��ĸ�ҳ��(��������ҳ���븸ҳ���н���,����ֱ�ӵ�����ҳ��),N:���ҳ�����Ƶ�������ҳ��</li>'+
			'<li>domSelectors:".textbox^.hisui-switchbox^#CardRegDOMTab!table!0" //��Ҫ����Ԫ�ص�ѡ���������ѡ������^�ָ���ѡ������ʽΪ�����ID!table!flag(flag:0 ���������У�1����������)</li>'+
			'<li>domNotSelectors:"".datebox^#SearchCode" //��Ҫ���˻����Ԫ��ѡ���������ѡ������^�ָ�</li>'+
		'};' +
		'<li>3������ҳ����� $.DHCDoc.CacheConfigPage();�ж�ҳ���Ƿ��ѻ���,1:�ѻ��� 0:δ���档 </li>'+
		'<li>4������ҳ����� $.DHCDoc.storageConfigPageCache();��������ҳ�����õ㡣 </li>'+
		'<li>5������csp��DHC_DocOrderPage������ҳ��DOM��DHC_DocPageDom </li>'+
		"</ul>" 
	$("#tip").popover({
		width:800,
		trigger:'hover',
		content:_content
	});
}