/** qunianpeng
  * 2019-06-14
  * 添加属性
 */ 
var extraAttr = "KnowType";			// 附加属性-知识类型
var extraAttrValue = "AttrFlag" 	// knowledge-实体
var editRow = 0;
var REPEATCODE=-98					// 重复代码、重复描述 定义为常量 (代码中尽量不要出现魔鬼数字)
var REPEATDESC=-99
var dicID=""
var IP=window.parent.ClientIPAddress;
function InitPageDefault(){
	
	
	//InitDefaultInfo();	/// 初始化界面默认信息
	InitAttrTree();		/// 初始化界面tree
	InitAttrList();		/// 初始化界面datagrid
	InitButton();  		/// 初始化按钮响应事件
	//InitCombobox();		/// 初始化页面combobox
	//ExportMatchDataNew()
	
}

/// 初始化按钮响应事件
function InitButton(){
	
	$('#icw_bt a:contains("取消")').bind("click",CloseWin);
	
	///  拼音码
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		var params = $HUI.searchbox("#queryCode").getValue();
			//var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
			//$("#attrtree").tree('options').url =encodeURI(url);
			//$("#attrtree").tree('reload');	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
			$("#attrtree").tree("search", params)		
			//$('#attrtree').tree('unselectAll');
	    }	   
	});
	///关联检索 2021-05-18  wangxuejian
	$('#linkCode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			//alert(searcode)
			findLinkTree(searcode);
		}
	});
}


/// 初始化界面tree
function InitAttrTree(){
	// 2020-03-20 添加停用过滤 Sunhuiyong
	var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	var option = {
		multiple: true,
		lines:true,
		animate:true,
        onClick:function(node, checked){
	       dicID=node.id;
	        var isLeaf = $("#attrtree").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        $('#attrlist').datagrid('load',{id:node.id,parrefFlag:1,loginInfo:LoginInfo}); 							   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    	$('#attrlist').datagrid('load',{id:node.id,parrefFlag:1,loginInfo:LoginInfo}); 
		    }
	    },
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			/*var node = $("#attrtree").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}*/
			$(this).tree('select', node.target);			
			//$('#attrlist').datagrid('load',{id:node.id,parrefFlag:1}); 
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#attrtree").tree('getChildren',node.target)[0];  /// 当前节点的子节点
	        var isLeaf = $("#attrtree").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("attrtree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		

}


/// 初始化datagrid
function InitAttrList(){
	
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}	
		
	// 定义columns
	var columns=[[ 
			{field:'ID',title:'RowId',hidden:true},
			{field:'CDCode',title:'代码',width:400,align:'left',editor:texteditor},
			{field:'CDDesc',title:'描述',width:400,align:'left',editor:texteditor},
			{field:'CDParref',title:'父id',width:100,align:'left',editor:texteditor,hidden:true},
			{field:'CDParrefDesc',title:'上层节点',width:300,align:'left',editor:texteditor},
			//{field:'Operator',title:'操作',width:300,align:'center',editor:typeeditor},
			{field:'CDLinkDr',title:'关联ID',width:100,align:'left',editor:texteditor,hidden:true},
			/*{field:'CDLinkDesc',title:'关联',width:300,align:'left',editor:texteditor,hidden:false},*/
			{field:'CDLinkDesc',title:'引用',width:300,align:'left',editor:texteditor,hidden:false},
			{field:'Operating',title:'操作',width:100,align:'center',formatter:SetCellOperation}		
		 ]]

	var option={	
		bordr:false,
		fit:true,
		fitColumns:true,
		singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90],
		onClickRow:function(rowIndex,rowData){
 		  if (editRow != ""||editRow == 0) {    //wangxuejian 2021-05-21  关闭编辑行 
                $("#attrlist").datagrid('endEdit', editRow); 
            } 
 		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
            if (editRow != ""||editRow == 0) { 
                $("#attrlist").datagrid('endEdit', editRow); 
            } 
            $("#attrlist").datagrid('beginEdit', rowIndex); 
            var editors = $('#attrlist').datagrid('getEditors', rowIndex);    //wangxuejian 2021-05-19 失去焦点关闭编辑行                
            for (var i = 0; i < editors.length; i++)   
            {  
                var e = editors[i]; 
              	$(e.target).bind("blur",function()
              	  {  
                   //$("#attrlist").datagrid('endEdit', rowIndex); 
                  });   
            } 
            
            editRow = rowIndex;
            //CommonRowClick(rowIndex,rowData,"#attrlist");
            dataGridBindEnterEvent(rowIndex);
        },
        onLoadSuccess:function(data){
          $(this).prev().find('div.datagrid-body').prop('scrollTop',0);
          $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({
              });
            }
          });          
        }	
		  
	}

	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=QueryDicByID&id=&parrefFlag="+"&loginInfo="+LoginInfo;
	new ListComponent('attrlist', columns, uniturl, option).Init();
	
}


/// 新增一行
function AddRow(){
	
	//commonAddRow({'datagrid':'#attrlist',value:{}});
	if(editRow>="0"){
		$("#attrlist").datagrid('endEdit', editRow);		//结束编辑，传入之前编辑的行
	}
	$("#attrlist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		row: {ID:'', CDCode:'', CDDesc:'',CDParref:"",CDLinkDr:""}
	});
	$("#attrlist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	
	editRow=0;
	dataGridBindEnterEvent(0);
}

/// 保存datagrid数据
function SaveRow(){

	var node = $("#attrtree").tree('getSelected');
	/*if (node == null){
		$.messager.alert("提示","请选择一个上级属性！","warning");
		return;
	}*/
	var parref = ""
	if (node != null){
		parref = $g(node.id);	
	}
	
	if(editRow>="0"){
		$("#attrlist").datagrid('endEdit', editRow);
	}

	var rowsData = $("#attrlist").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		
		if((rowsData[i].CDCode=="")||(rowsData[i].CDDesc=="")){
			$.messager.alert("提示","代码或描述不能为空!"); 
			return false;
		}
		
		if ((parref=="")&(rowsData[i].ID=="")&(rowsData[i].CDParref=="")){	// 在右侧界面直接新增时，需要上级属性
			$.messager.alert("提示","请选择一个上级属性！","warning");
			return false;
		}
		
		if ((parref == "")&(parref != rowsData[i].CDParref)){		// 修改本身
			parref = rowsData[i].CDParref;
		}
		
		if ((parref != "")&(parref == rowsData[i].ID)){				// 修改本身
			parref = rowsData[i].CDParref;
		}
		
		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc)+"^"+$g(parref)+"^"+$g(rowsData[i].CDLinkDr);
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//保存数据   Sunhuiyong-修改增加日志 2020-11-23
	//runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LoginInfo":LoginInfo,"ClientIPAddress":IP},function(jsonString){
		if (jsonString>=0 ){
			$.messager.alert('提示','保存成功！','info');
			
		}
		if (jsonString == REPEATCODE){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');

		}else if (jsonString == REPEATDESC){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
		}		
		RefreshData();
	});
	
	/*
	comSaveByDataGrid("User.DHCCKBCommonDiction","#attrlist",function(){
			$('#attrlist').datagrid('load',{id:""}); 
			var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryAttrTreeList&params=';
			$("#attrtree").tree('options').url =encodeURI(url);
			$("#attrtree").tree('reload');	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
	})*/
}

/// 删除
function DeleteRow(){
	var params=dicID;
	if (params != 0) {
		$.messager.confirm("提示", "您确定要停用这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","IsDicUsed",{"DicIdList":params},function(jsonString){
					if (jsonString == 0){
						SetFlag="stop"        //停用数据标记
						DicName="DHC_CKBCommonDiction"
						dataid=params;
						Operator=LgUserID
						var StopDate=formatDate(0);
						var d = new Date();
						var n = d.getHours();	// 时
						var m = d.getMinutes();	// 分
						m = m<10?"0"+m:m;
						var s = d.getSeconds(); // 秒
						s = s<10?"0"+s:s;
						var StopTime=n+":"+m+":"+s;
						//$HUI.dialog("#diclog").open();
						//var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP+"&type="+"log";
						//window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
						runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":dataid,"Function":SetFlag,"Operator":LgUserID,"OperateDate":StopDate,"OperateTime":StopTime,"Scope":"","ScopeValue":"","ClientIPAddress":IP,"Type":'log'},function(getString){
							if (getString == 0){
								Result = "操作成功！";
							}else if(getString == -1){
								Result = "当前数据存在引用值,不允许删除";
							}else{
								Result = "操作失败！";	
							}
						},'text',false);
						$.messager.popover({msg: Result,type:'success',timeout: 1000});					
						RefreshData();
					}else if (jsonString == "-1"){
						$.messager.alert('提示','该数据已被引用,不能直接停用！','warning');
					}		
				})
			}
		});		
	}else{
		 $.messager.alert('提示','请选择要停用的项','warning');
		 return;
	}	 



	/*removeCom("User.DHCCKBCommonDiction","#attrlist",function(jsonstr){
		var obj = jQuery.parseJSON(jsonstr)
		if (obj.code == 0){
			var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryAttrTreeList&params=';
			$("#attrtree").tree('options').url =encodeURI(url);
			$("#attrtree").tree('reload');
			$('#attrlist').datagrid('load',{params:""}); 
		}
	});
	*/
}
function reloadDatagrid()
{
	$("#attrtree").tree('reload');	
}
/// 属性dialog悬浮
function dataGridBindEnterEvent(index){
	
	editRow=index;
	var editors = $('#attrlist').datagrid('getEditors', index);

	for(var i=0;i<editors.length;i++){
		var workRateEditor = editors[i];
		
		//类型  CDType
		if(workRateEditor.field=="CDParrefDesc"){
			workRateEditor.target.mousedown(function(e){
				var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParrefDesc'});		
				var input = $(ed.target).val();
			    /*divComponent({tarobj:$(ed.target),htmlType:"tree",width: 400,height: 260},function(obj){
					var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParref'});		
					$(ed.target).val(obj.id);				
				})*/
				var Clicktype="ParrefDesc"
				ShowAllData(index,Clicktype);	 //wangxuejian 2021-05-18 区别是关联类型还是上一层级类型			
			});
			
		//关联id CDLinkDesc
		}else if(workRateEditor.field=="CDLinkDesc"){
			workRateEditor.target.mousedown(function(e){				
				var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDesc'});		
				var input = $(ed.target).val();
				var Clicktype="LinkDesc"      //wangxuejian 2021-05-18 区别是关联类型还是上一层级类型
				ShowAllData(index,Clicktype);								
			});
		}			
		else{
			workRateEditor.target.mousedown(function(e){
					$("#win").remove();;
			});
			workRateEditor.target.focus(function(e){
					$("#win").remove();;
			});
		}
	}
}

///设置操作明细连接
function SetCellOperation(value, rowData, rowIndex){

	///<a href='#' onclick=\"showAuditListWin('"+a+"','"+a+"')\"><img src='../scripts/dhcnewpro/images/adv_sel_11.png' border=0/>集合</a>";
	/*var btnGroup="<a style='margin-right:10px;display:none' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','list','"+rowData.DataType+"')\">集合</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;display:none' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','prop','"+rowData.DataType+"')\">属性</a>";
	btnGroup = btnGroup + "<a style='margin-right:10px;' href='#' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\">附加属性</a>";
	
	return btnGroup;
	*/
	
	//var btn = "<img class='mytooltip' title='附加属性' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    var btn = "<a class='icon icon-compare' style='color:#000;display:inline-block;width:16px;height:16px' title='附加属性' onclick=\"OpenEditWin('"+rowData.ID+"','linkprop','"+rowData.DataType+"')\"></a>" 
    return btn;  
	
}

/// 属性值编辑框
function OpenEditWin(ID,model,dataType){

	var linkUrl="",title=""
	if (model == "list"){
		
		linkUrl = "dhcckb.addlist.csp"
		title = "字典维护"
		
	}else if (model =="prop"){
		
		linkUrl = "dhcckb.addattr.csp";
		title = "属性列表";
		
	}else if (model == "linkprop"){
		
		linkUrl = "dhcckb.addlinkattr.csp";
		title ="附加属性维护";
		
	}else {
		linkUrl = "dhcckb.addlist.csp"
		title = "字典维护"
	}	
	linkUrl += '?parref='+ID;
	if ("undefined"!==typeof websys_getMWToken){
		linkUrl += "&MWToken="+websys_getMWToken(); 
	}
	var openUrl = '<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+linkUrl+'"></iframe>';	
	if($('#winmodel').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="winmodel"></div>');
	$('#winmodel').window({
		iconCls:'icon-w-save',
		title:title,
		collapsible:true,
		border:false,
		closed:"true",
		modal:true,
		//maximized:true,
		maximizable:true,
		minimizable:false,		
		width:$(window).width()-50, //800,
		height:$(window).height()-50//500
	});	

	$('#winmodel').html(openUrl);
	$('#winmodel').window('open');

}

/// 新建属性窗口
function newCreateAttr(type){	
		
	if (type == "C"){
		var node = $("#attrtree").tree('getSelected');
		if ((node)&&(node.text.indexOf("属性根节点")!=-1)){
			 $.messager.alert('提示','属性根节点只能添加同级节点','info');
			 return;
		}
	}
	newCreateAttrWin(type);   // 新建属性窗口
	InitAttrWinDefault(type); // 初始化界面默认信息
}

/// Window 定义
function newCreateAttrWin(type){
	
	/// 分类窗口
	var option = {
		modal:true,
		collapsible:true,
		border:true,
		minimizable : false,
		iconCls:'icon-w-save',
		closed:"true"
	};
	
	var title = "增加下级属性";
	if (type == "S"){
		title = "增加同级属性";
		$("#saveSub").hide();
		$("#saveParref").show();
	}
	if (type == "C"){
		$("#saveParref").hide();
		$("#saveSub").show();
	}
	
	new WindowUX(title, 'AttrWin', '400', '220', option).Init();
}

/// 属性树右键保存
function SaveAttr(type){

	var attrID = $("#attrID").val();
	var attrCode = $("#attrCode").val();    /// 属性代码
	if ($g(attrCode) == ""){
		 $.messager.alert('提示','代码不能为空','warning');
		 return;
	}
	var attrDesc = $("#attrDesc").val();    /// 属性描述
	if ($g(attrDesc) == ""){
		 $.messager.alert('提示','描述不能为空','warning');
		 return;
	}
	var parref=$("#parref").val();
	
	var params=$g(attrID) +"^"+ $g(attrCode) +"^"+ $g(attrDesc) +"^"+ $g(parref)

	var attrData = extraAttr +"^"+ extraAttrValue;
	if (type == "C"){	// 增加子节点时，子节点不需要维护知识类别
		attrData = "";
	}
	var node = $("#attrtree").tree('getSelected');
	if (node){
		var parentNode=$("#attrtree").tree("getParent",node.target)	// 选择节点的父节点
		if (parentNode){											
			attrData = "";
		}
	}

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdate",{"params":params,"attrData":attrData},function(jsonString){
		if (jsonString >= 0){
			
			RefreshData();
			CloseWin();
			$('#attrlist').datagrid('reload'); //重新加载
			return;	
		}else if (jsonString == REPEATCODE){
			$.messager.alert('提示','代码重复,请核实后再试！','warning');
			RefreshData();
			CloseWin();
			return;
		}else if (jsonString == REPEATDESC){
			$.messager.alert('提示','描述重复,请核实后再试！','warning');
			RefreshData();
			CloseWin();
			return;
		}
		else{
			$.messager.alert('提示','保存失败！','warning');			
		}		
	});

}

/// 关闭窗口
function CloseWin(){
	$('#AttrWin').window('close');
}

/// 初始化界面默认信息
function InitAttrWinDefault(type){
	
	var node = $("#attrtree").tree('getSelected');
	$("#attrCode").val("");
	$("#attrDesc").val("");
	if (type == "S"){		// 同级
		if (node){
			var parentNode=$("#attrtree").tree("getParent",node.target)	// 选择节点的父节点
			if (parentNode){											// 选择节点的父节点，设置为上级节点为父节点
				$("#parref").val(parentNode.id);
				$("#parrefDesc").val(parentNode.text);
			}else{
				$("#parref").val("");
				$("#parrefDesc").val("");
			}
		}
	}		
	if (type == "C"){	// 下级
		$("#parref").val(node.id);
		$("#parrefDesc").val(node.text);
	}	
}

/// 属性树查询
function QueryAttrTreeList(){
	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		var params = $HUI.searchbox("#queryCode").getValue();
			//var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
			//$("#attrtree").tree('options').url =encodeURI(url);
			//$("#attrtree").tree('reload');	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
			$("#attrtree").tree("search", params)
			//$('#attrtree').tree('unselectAll');
	    }	   
	});
}

/// 刷新
function RefreshData(){
	
	$HUI.searchbox('#queryCode').setValue("");
	searchData();
	//QueryAttrTreeList();
	//var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	//$("#attrtree").tree('options').url =encodeURI(url);
	//$("#attrtree").tree('reload');
	$('#attrlist').datagrid('reload'); //重新加载
}
///属性datagrid
function reloadPagedg()
{
}
/// 导出（后台导出下载测试）
function ExportMatchDataNew(){
	
	/* var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"测试数据", //默认DHCCExcel
		ClassName:"web.DHCCKBGetDicSourceUtil",
		QueryName:"QueryDicByDeleteMsg"	
	},false);
 */
 var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:"测试数据", //默认DHCCExcel
		ClassName:"web.DHCCKBCommon",
		QueryName:"ExportReplatRuleDic"	
	},false);

	location.href = rtn;

}

function ShowAllData(index,Clicktype)
{
	var title = (Clicktype == "ParrefDesc")?"修改上层节点":(Clicktype == "LinkDesc")?"修改引用":"添加";
    $("#myWin").show();
    var myWin = $HUI.dialog("#myWin",{
        iconCls:'icon-w-save',
        resizable:true,
        title:title,
        modal:true,     
        buttonAlign : 'center',
        buttons:[{
            text:'保存',
            id:'save_btn',
            handler:function(){
                GetLink(index,Clicktype);
                  myWin.close();                    
            }
        },{
            text:'关闭',
            handler:function(){                              
                myWin.close(); 
            }
        }],
        onClose:function(){

        }
    });
    SetTabsInit(index,Clicktype)
    var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#linktree").tree('options').url =(uniturl);
	$("#linktree").tree('reload');
}


/// 初始化弹出的树
function SetTabsInit(index,Clicktype){
	// 属性
	var myAttrTree = $HUI.tree("#linktree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,     	//是否树展开折叠的动画效果
		onClick:function(node) 
        {
	       GetLink(index,Clicktype)  //单击获取树的数据 
        }
	});
		
}

function searchData(){
	
   	var params = $HUI.searchbox("#queryCode").getValue();
	$("#attrtree").tree("search", params)		
	//$('#attrtree').tree('unselectAll');

}

/// 获取--关联、上一层次的数据
function GetLink(index,Clicktype)
{
		var linkrow= $('#linktree').tree('getSelected');	// 获取选中的行 
		//alert(linkrow)
	    if((linkrow==null)&&(Clicktype=="LinkDesc"))
	    {
		 var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDr'});		
	     $(ed.target).val("")
	     var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDesc'});		
	     $(ed.target).val("")
	     return ; 
	    }
	    if((linkrow==null)&&(Clicktype=="ParrefDesc"))
	    {
		 var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParref'});		
	     $(ed.target).val("")
	     var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParrefDesc'});		
	     $(ed.target).val("")
	      return ; 
	    }
		var selectID=linkrow.id; 
		var selectDesc=linkrow.text;
		var selectCode=linkrow.code;
		if(Clicktype=="LinkDesc")
		{
		var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDr'});		
	    $(ed.target).val(selectID)
	    var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDLinkDesc'});		
	    $(ed.target).val(selectDesc)
		}
		if(Clicktype=="ParrefDesc")
		{
		var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParref'});		
	    $(ed.target).val(selectID)
	    var ed=$("#attrlist").datagrid('getEditor',{index:index, field:'CDParrefDesc'});		
	    $(ed.target).val(selectDesc)
		}

}

///检索树
function findLinkTree(searcode)
{
	var url = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#linktree").tree('options').url =encodeURI(url);
	$("#linktree").tree('reload');
}

///清屏
function LinkRefresh()
{
    $HUI.searchbox("#linkCode").setValue("");
	var searcode=$HUI.searchbox("#linkCode").getValue();
	findLinkTree(searcode)
}

function serchlink(){
   	var searcode = $HUI.searchbox("#linkCode").getValue();
	findLinkTree(searcode)
	}
/// JQuery 初始化页面
$(function(){ InitPageDefault(); })
