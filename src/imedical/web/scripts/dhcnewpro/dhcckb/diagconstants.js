var hisCode="";
var hisDesc="";
var libCode="";
var libDesc="";				// 知识库描述 sufan2020-07-10 由于早期数据code有重复情况，增加描述和code双重过滤
var selHospId = "";			
var contrastEditRow = 0;		// 
var witchFlag = ""	// 点击标记 点击his树flag置1 点击系统表置为2

/// 页面初始化函数
function InitPageDefault(){
	
	//InitParams();	// 初始化参数
	InitDataGrid();	// 初始化datagrid
	InitTree();		// 初始化树
	InitButton();	// 初始化button
	InitCombobox();	// 初始化combobox
	
}

/// 初始化参数
function InitParams(){}

/// 初始化button
function InitButton(){
	
	///查询分类
     $('#FindTreeText').searchbox({
	    searcher:function(value,name){
		   ReloadTree();
	    }	   
	});	

	// 点击事件绑定
	$('#sysSearch').bind("click",QueryLibList);
	
	// 回车事件绑定
	$('#sysDesc').bind("keyup",function(event){
		if(event.keyCode == "13"){
			QueryLibList();
		}
	});
	
	///是否匹配 
	$('#match').radio({onCheckChange:function(){
		QueryLibList();
	}})
	
	///是否匹配(his诊断)
	$('#hismatch').radio({onCheckChange:function(){
		ReloadTree();
	}})

}

/// 初始化combobox
function InitCombobox(){
	
	/// 初始化病症关系检索框
	var option = {
		panelHeight:"auto",
		mode:"remote",		
		valueField: "id", 
		textField: "text"       
	}; 
	var url = "" //$URL +"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+symptomRelId；
	new ListCombobox("symList",url,'',option).init(); 
	
		/// 初始化参考依据检索框
	var option = {
		panelHeight:"auto",
		mode:"remote",
		valueField:'id',
		textField:'text',
		multiple:true       
	}; 
	var url = "" //$URL + "?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+referenceId;
	new ListCombobox("refList",url,'',option).init(); 	
}

/// 初始化datagrid
function InitDataGrid(){
	
	//初始化知识库表	
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'check',title:'sel',checkbox:true},  //xww 2021-08-13
			{field:'CDCode',title:'代码',width:100,sortable:true,align:'left'},
			{field:'CDDesc',title:'描述',width:100,align:'left'},
			{field:'Parref',title:'父节点id',width:100,align:'left',hidden:true},
			{field:'ParrefDesc',title:'父节点',width:100,align:'left',hidden:true},
			{field:'CDLinkDr',title:'关联',width:100,align:'left',hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:100,align:'left',hidden:true},
			{field:'KnowType',title:"数据类型",width:100,align:'left',hidden:true}					
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		remoteSort:false,
		pageSize:30,
		pageList:[30,60,90],		
 		onClickRow:function(index,row) {    
 			libCode = row.CDCode;
 			libDesc = row.CDDesc;		//sufan 2020-07-10 增加取desc和code双重过滤，code存在重复情况
  			witchFlag = 2;
  			QueryContrastList();
        },		
        onLoadSuccess:function(data){
           $(this).prev().find('div.datagrid-body').prop('scrollTop',0);              
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id="+diseaseId+"&parrefFlag=0&parDesc="+""+"&loginInfo="+LoginInfo+"&dataMirFlag=";
	new ListComponent('sysgrid', columns, uniturl, option).Init();
	
			
	var symEditor={  //设置其为可编辑
		// 病症关系
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+symptomRelId,
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCSymRelat'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCSymRelatDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	
	var refEditor={  //设置其为可编辑
		// 参考依据
		type: 'combobox',//设置编辑格式
		options: {
			valueField: "id", 
			textField: "text",
			url:LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+referenceId,
			//required:true,
			panelHeight:"auto",  //设置容器高度自动增长
			onSelect:function(option){
				///设置类型值
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCReference'});
				$(ed.target).combobox('setValue', option.text); 
				var ed=$("#constgrid").datagrid('getEditor',{index:editRow,field:'CCReferenceDr'});
				$(ed.target).val(option.id); 
			} 
		}
	}
	//初始化对照关系表
	/**
	 * 定义对照关系表的columns
	 */
	var contrastcolumns=[[
		{field:'CCRowID',title:'id',width:100,hidden:true,sortable:true},
		{field:'check',title:'sel',checkbox:true},   //xww 2021-07-06
        {field:'CCLibCode',title:'知识库代码',width:100,sortable:true,hidden:true},
        {field:'CCLibDesc',title:'知识库描述',width:100,sortable:true},
        {field:'CCHisCode',title:'His代码',width:100,sortable:true},
        {field:'CCHisDesc',title:'His描述',width:100,sortable:true},
        {field:'CCSymRelatDr',title:'病症关系Dr',width:100,hidden:true},
        {field:'CCSymRelat',title:'病症关系',width:100},  //editor:symEditor
        {field:'CCReferenceDr',title:'参考依据Dr',width:100,hidden:true},
        {field:'CCReference',title:'参考依据',width:100}, //editor:refEditor
        {field:'CCUser',title:'操作人',width:60},
        {field:'hospDesc',title:'医院',width:100,sortable:true,hidden:true},
        {field:'CCDicTypeDesc',title:'实体类型',width:100,sortable:true,hidden:true},
        {field:'Source',title:'审核状态',width:80,
        	formatter:function(value,row,index){ 
					 if(value=='confirm'){
						 return "已审核";
					 }
					 else if(value=='sourcecdss'){
						 return "已审核";
					 }
					 else if(value=='sourcebgdata01'){
						 return "已审核";
					 }
					 else if(value=='sourcebgdata02'){
						 return "已审核";
					 }
					 else{
						  return value;
					 }
			} 
        },
        {field:'AuditSta',title:'来源',width:80,
        	formatter:function(value,row,index){ 
			
					 if(value=='confirm'){
						 return "";		//逸曜
					 }
					 else if(value=='sourcecdss'){
						 return "CDSS";
					 }
					 else if(value=='sourcebgdata01'){
						 return "cdss大数据合集";
					 }
					 else if(value=='sourcebgdata02'){
						 return "cdss";
					 }
					 else{
						  return value;
					 }
	
			} 
        },
        {field:'opt',title:'操作',width:100,align:'center',
			formatter:function(value,row,index){ 
				var btn =  '<img class="contrast" onclick="DeleteConstSym('+row.CCRowID+')" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" style="border:0px;cursor:pointer">' 
				return btn;  
			}  
        }
	]];
	
	/**
	 * 定义对照关系表的datagrid
	 */
	var congrid = $HUI.datagrid("#constgrid",{
	    url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBDiagconstants",
			QueryName:"QueryContrastList",
			rowID:"",
			type:diseaseId,		
			loginInfo:LoginInfo
	    },
        columns: contrastcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        //singleSelect:true,
        idField:'CCRowID',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        //toolbar:[],//表头和数据之间的缝隙
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动  
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        },
        onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
        },
        onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (contrastEditRow != ""||contrastEditRow == 0) { 
                $("#constgrid").datagrid('endEdit', contrastEditRow); 
            } 
            $("#constgrid").datagrid('beginEdit', rowIndex);                
            contrastEditRow = rowIndex; 
        }        
        
    	});
     $('#constgrid').datagrid('loadData',{total:0,rows:[]});  // 用空数据填充datagrid
}


/// 初始化tree
function InitTree(){

	$('#diagtree').tree({
    	//url:LINK_CSP+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+extDiagId,
    	url:$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+ICDDiagDataId,
    	lines:true,
		animate:true,
		dnd:true,
		checkbox:true,
		onSelect: function(node){
	     	//用state来接收当前点击节点的选中状态，true代表选中，false代表未选中
			var state = node.checked;
			//alert(node.checked);
			if(state==true){
			    //选中则将其设为未选中
			 $("#diagtree").tree('uncheck',node.target);
			}else if(state==false){
			   //未选中则将其设为选中
			 $("#diagtree").tree('check',node.target);
			}
			hisCode = node.code;
			hisDesc = node.text;
			witchFlag = 1;
			QueryContrastList();
	     },
		
		onContextMenu: function(e, node){			
			e.preventDefault();
			$('#ruleTree').tree('select', node.target);
			// 显示快捷菜单
			$('#treeMenu').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
		onClick:function(node, checked){
		
	    },
	    onBeforeDrag:function(data){
		   /// 拖拽前事件，返回false则不允许移动此节点
		   var node=$(this).tree('getSelected');
		   if (node === null){return;} 
		   var isLeaf=$(this).tree('isLeaf',node.target);
		   if(isLeaf==false){return false;}
		},
	    onBeforeDrop:function(target,source){       
　　　　 	
        },
        onDrop:function(target,source,operate){        	
            
        },
        onLoadSuccess:function(node,data){	      
	    }
	});
}
/// 加载树
function ReloadTree(){
	//var desc=$.trim($("#FindTreeText").val());
	//$("#dictree").tree("search", desc)
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
	var matchFlag = $HUI.checkbox("#hismatch").getValue();
	matchFlag = matchFlag==true?"N":"";
	var Input=$.trim($HUI.searchbox("#FindTreeText").getValue());
	//var url = $URL+"?ClassName=web.DHCCKBExtDictionary&MethodName=GetTreeJsonDataByNode&id="+extDiagId +"&Input="+Input +"&matchFlag="+matchFlag;
	//var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+ICDDiagDataId +"&Input="+Input;
	if(Input==""){
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonDataByNode&id="+ICDDiagDataId+"&Input=";
	}else{
		var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJsonData&parref="+ICDDiagDataId+"&Input="+Input;
	}
	
	$('#diagtree').tree('options').url =encodeURI(url);
	$('#diagtree').tree('reload');

}

///数据批量对照前的验证
function CheckCondata(){
	
	/* his 诊断 */
	var nodes = $('#diagtree').tree('getChecked');
	if (nodes.length==0){
		$.messager.alert('提示','请至少选择一个诊断！','info');
		return;
	} 

	/* 安全用药疾病库 */
  	var libData = $('#sysgrid').datagrid('getSelections');		
	if(libData.length==0){
		$.messager.alert('提示','请选择系统疾病再进行对照！','info');
		return;
	}
	
	var dataList = []; 
	for(var i=0;i<nodes.length;i++)
	{	
		//只需要保留最后一层
		if (nodes[i].children != undefined){
		 	continue;
		}
		for(var j=0;j<libData.length;j++)
		{
			var tmp = libData[j].CDCode +"^"+ libData[j].CDDesc +"^"+ nodes[i].code +"^"+ nodes[i].text +"^"+ diseaseId +"^"+ nodes[i].id; // diseaseId 西医疾病字典id
			dataList.push(tmp);
		}
	}
	var params=dataList.join("&&");
	var hospId = "";
	OpenSymWin(1,params,hospId);
	
}

/// 数据对照
function Condata(params,hospId,symData){	
	runClassMethod("web.DHCCKBComContrast","saveConDataBat",{"params":params,"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"selHospId":hospId,"symData":symData},function(jsonString){
		if (jsonString == '0') {
			$.messager.popover({msg: '对照成功！',type:'success',timeout: 1000});
		}else{
			var errorMsg ="对照失败！"
			$.messager.alert('操作提示',errorMsg+"错误代码："+jsonString,"error");				
		}			
		QueryContrastList();
	},'text',false);	
	
}

/// 查询知识库字典数据
function QueryLibList(){
	if(diseaseId==""){
		$.messager.alert('操作提示',"请选择一个类型","info");
		return;
	}
	var genDesc = $('#sysDesc').val();  // 临床知识库描述
	var genMatch = $HUI.checkbox("#match").getValue(); //xww 未匹配项 2021-08-26
	$('#sysgrid').datagrid('load',{
		id:diseaseId,
		parrefFlag:0,
		parDesc:genDesc,
		loginInfo:LoginInfo,
		dataMirFlag:"",
		genMatchFlag:genMatch  //xww 2021-08-26 安全用药库未匹配标志
	}); 
	$('#sysgrid').datagrid('unselectAll');  // 清空列表选中数据 	
}

/// 查询对照数据
function QueryContrastList()
{
	var selHospDesc = "";
	var constrID = "";
	$('#constgrid').datagrid('load',  {
		ClassName:"web.DHCCKBDiagconstants",
		QueryName:"QueryContrastList",
		 rowID:constrID,			
		 type:diseaseId, 
		 queryLibCode:(witchFlag==2)?libCode:"",
		 queryLibDesc:(witchFlag==2)?libDesc:"",
		 queryHisCode:(witchFlag==1)?hisCode:"",
		 queryHisDesc:(witchFlag==1)?hisDesc:"",
		 loginInfo:LoginInfo,
		 selHospDesc:selHospDesc		
    });
    
    $('#constgrid').datagrid('unselectAll');  // 清空列表选中数据 	
}

/// 批量修改病症关系和参考依据
function CheckUpdateDiagnosRel(){
	
	/* 已对照数据 */
  	var constData = $('#constgrid').datagrid('getSelections');		
	if(constData.length==0){
		$.messager.alert('提示','请选择数据后再进行修改！','info');
		return;
	}
	
	OpenSymWin(2,"","");
}
/// 批量修改病症关系和参考依据
function BatchUpdateDiagnosRel(symData,refData){

	if ((symData == "")&&(refData=="")){
		$.messager.alert('提示','请选择数据后再进行修改！','info');
		return;
	}
	/* 已对照数据 */
  	var constData = $('#constgrid').datagrid('getSelections');		
	var constArr= [];
	var refArr = [];
	var symId = "";
	for(var i=0;i<constData.length;i++)	{
		constArr.push(constData[i].CCRowID);
		//refArr.push(constData[i].CCReferenceDr);
		//symId = constData[i].CCSymRelatDr;
	}

	var constStr = constArr.join("^");	
	UpdateDiagnosRel(constStr,symData,refData);
}

/// 修改病症关系和参考依据
function UpdateDiagnosRel(constStr,symId,refStr){
	
	runClassMethod("web.DHCCKBDiagconstants","UpdateDiagnosRel",{"constStr":constStr,"symId":symId,"refStr":refStr},function(jsonString){
		
		if (jsonString == '0') {
			$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
		}else{
			var errorMsg ="修改失败！"
			$.messager.alert('操作提示',errorMsg+"错误代码："+jsonString,"error");				
		}			
		QueryContrastList();
	},'text',false);
}


/// 保存数据对照时,增加疾病关系选择
function OpenSymWin(flag,params,hospId) {
	
	CleanCombobox();
	$("#symWin").show(); 
	var url = $URL +"?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+symptomRelId;
	$('#symList').combobox('reload',url); 
	
	var url = $URL + "?ClassName=web.DHCCKBDiction&MethodName=QueryDicComboboxByID&id="+referenceId;
	$('#refList').combobox('reload',url);
	
	var myWin = $HUI.dialog("#symWin",{
		iconCls:'icon-w-save',
		resizable:true,
		title:'病症关系',
		modal:true,
		//height:$(window).height()-70,
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){				
				var symArr= $("#symList").combobox('getValues');
				var refArr  = $("#refList").combobox('getValues');
				var symData = symArr.join("^") + "&&" + refArr.join("^");
				if (flag ==1){	// 数据对照保存方法
					Condata(params,hospId,symData);
				}
				else{	// 直接修改病症关系方法
					BatchUpdateDiagnosRel(symArr.join("^"),refArr.join("^"));
				}
				myWin.close();
			}
		},{
			text:'关闭',
			//iconCls:'icon-cancel',
			handler:function(){
				myWin.close();
			}
		}]
	});
}
	
/// 删除对照关系
function DeleteConstSym(constId){
	
	runClassMethod("web.DHCCKBDiagconstants","DeleteConstSym",{"constId":constId},function(jsonString){		
		if (jsonString == '0') {
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
		}else{
			$.messager.popover({msg: '删除失败！',type:'success',timeout: 1000});				
		}			
		QueryContrastList();
	},'text',false);
}


/// 清除下拉框默认数据
function CleanCombobox(){
	
	$('#symList').combobox('clear'); 	
	$('#refList').combobox('clear');
}

/// 系统列表重置
function ClearLibData(){
	$('#sysgrid').datagrid('clearChecked'); 
	$('#sysgrid').datagrid('clearSelections'); 
	libCode="";
	libDesc="";	
	$("#sysDesc").val("");
}

/// his列表重置
function ClearHisData(){
	$('#FindTreeText').searchbox('setValue','');
	InitTree();
	hisCode="";
	hisDesc="";

}

///核实--sufan 2022-06-01
function sureoprat(comflag)
{
	var confirmDate=SetDateTime("date");
	var confirmTime=SetDateTime("time");
	var setFlag="confirm";        //核实数据标记
	if(comflag==1){
		var setFlag="confirm";        //核实数据标记
	}else{
		var setFlag="cancelconfirm";        //核实数据标记

	}
	var dicName="DHC_CKBComContrast";
	var operator=LgUserID
	var conArr = [];
	var selItems = $('#constgrid').datagrid('getSelections');
	for(var i=0;i<selItems.length;i++){
		var conId = selItems[i].CCRowID;
		var source = selItems[i].Source;
		if((comflag == 1)&&(source==1)){continue;}
		if((comflag == -1)&&(source!=1)){continue;}
		conArr.push(conId);
		
	}
	var params = conArr.join("&&");
	runClassMethod("web.DHCCKBWriteLog","InsertAllDicLog",{"DicDr":dicName,"params":params,"Function":setFlag,"Operator":operator,"OperateDate":confirmDate,"OperateTime":confirmTime,"Scope":"","ScopeValue":"","ClientIPAddress":'',"Type":"log"},function(getString){
		if (getString == 0){
			Result = "操作成功！";
		}else{
			Result = "操作失败！";	
		}
	},'text',false);
	$.messager.popover({msg: Result,type:'success',timeout: 1000});
	$('#constgrid').datagrid('reload');
	
	
}

function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

/// JQuery 初始化页面
$(function(){ InitPageDefault(); })