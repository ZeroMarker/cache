//===========================================================================================
// Author：      Sunhuiyong
// Date:		 2020-03-20
// Description:	 新版临床知识库-停用数据
//===========================================================================================
var editRow = 0,editsubRow=0;
var extraAttr = "KnowType";			// 知识类型(附加属性)
var extraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
var parref="";
var IP=window.parent.ClientIPAddress;
var ChkValue=""
var flagValue = "1"
/// 页面初始化函数
function initPageDefault(){
	
	InitButton();		// 按钮响应事件初始化
	InitCombobox();		// 初始化combobox
	InitDataList();		// 页面DataGrid初始化定义
	InitTree();     	// 初始分类树
	InitSubDataList()	// 字典表
}

/// 页面DataGrid初始定义通用名
function InitDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns
	var columns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left',editor:texteditor},
			{field:'CDDesc',title:'描述',width:300,align:'left',editor:texteditor},
			{field:'Parref',title:'父节点id',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'ParrefDesc',title:'父节点',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDr',title:'关联',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'CDLinkDesc',title:'关联描述',width:300,align:'left',editor:texteditor,hidden:true},
			{field:'KnowType',title:"知识类型",width:200,align:'left',hidden:true},
			{field:'DataType',title:"数据类型",width:200,align:'left',hidden:true},
			{field:'IsStop',title:"状态",width:200,align:'left',formatter:function(value,row,index){
				if(value==1)
				{
					return "启用"
				}else if(value==0)
				{
					return "停用"	
				}
				},hidden:false}
			
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
		   parref = rowData.ID;
		   var flagStop = $HUI.checkbox("#dd1").getValue();
		   //alert(flagStop)
		   if(flagStop==false)
		   {
			flagValue = 1
		   	$("#subdiclist").datagrid("load",{"DataID":parref,"flagValue":flagValue});
		   }else
		   {
			flagValue = 0
			$("#subdiclist").datagrid("load",{"DataID":parref,"flagValue":flagValue}); 
		   }
		}, 
		onDblClickRow: function (rowIndex, rowData) {//双击选择行编辑
          
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
	var uniturl = $URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&userID="+LgUserID+"&locID="+LgCtLocID+"&groupID="+LgGroupID+"&hospID="+LgHospID+"&params=";
	new ListComponent('diclist', columns, uniturl, option).Init();
	
}


/// 按钮响应事件初始化
function InitButton(){
	
	$("#reset").bind("click",InitPageInfo);	// 重置
	$("#reuse").bind("click",ReuseDic);	// 重置
	/// 代码.描述查询
	//$("#code,#desc").bind("keypress",QueryDicList);	
	$('#queryCode').searchbox({
	    searcher:function(value,name){
	   		QueryDicList();
	    }	   
	});	
	
	$('#subQueryCode').searchbox({
	    searcher:function(value,name){
	   		SubQueryDicList();
	    }	   
	});
	
	$("#subinsert").bind("click",SubInsertRow);	// 增加新行
	
	$("#subsave").bind("click",SubSaveRow);		// 保存
	
	$("#subdel").bind("click",SubDelRow);	// 删除
	
	$("#acdataflag").bind("click",AcDataFlag);	// 核实
	
	$("#setparref").bind("click",ResetParref);	// 重置字典指向
	
	$("#settreeparref").bind("click",ResettreeParref);	// 重置字典指向-tree
	
	//$("#subfind").bind("click",SubQueryDicList);	// 查询
	
	$("#resetsub").bind("click",InitSubPageInfo);	// 重置
	
	/// tabs 选项卡
	$("#tabs").tabs({
		onSelect:function(title){
			
		   	LoadattrList(title);
		}
	});
	
	///属性检索
	$('#attrtreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			findattrTree(searcode);
		}
	});
	
	///属性检索
	$('#dictreecode').searchbox({
		searcher : function (value, name) {
			var searcode=$.trim(value);
			finddicTree(searcode);
		}
	});
	
	///实体
	$('#entityCode').searchbox({
	    searcher:function(value,name){
	   		QueryWinDicList();
	    }	   
	});
	
	$("#resetwin").bind("click",InitPageInfoWin);	// 重置
	
	$('#myChecktreeDesc').searchbox({
	    searcher:function(value,name){
		    finddgList(value);
	    }	   
	});	
	
	$HUI.radio("[name='FilterCK']",{
        onChecked:function(e,value){
	        ChkValue=this.value;
	       	var seavalue=$HUI.searchbox("#myChecktreeDesc").getValue();
	       	finddgList(seavalue);
        }
     });
}

/// 初始化combobox
function InitCombobox(){	
}

// 查询
function QueryDicList()
{
	var params = $HUI.searchbox("#queryCode").getValue();
	
	$('#diclist').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:extraAttrValue,
		params:params
	}); 
}

// 重置 
function InitPageInfo(){
	
	//$("#code").val("");
	//$("#desc").val("");
	$HUI.searchbox('#queryCode').setValue("");
	QueryDicList();	

}
// 启用字典 Sunhuiyong 2020-04-03
function ReuseDic()
{
	var rowsData = $("#diclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要启用该字典？", function (res) {	// 提示是否删除
			if (res) {
				var OperateDate=SetDateTime("date");
				var OperateTime=SetDateTime("time");
				runClassMethod("web.DHCCKBWriteLog","ReUseData",{"StopRowID":rowsData.ID,"DicID":rowsData.ID,"LgUserID":LgUserID,"OperateDate":OperateDate,"OperateTime":OperateTime,"ClientIPAddress":ClientIPAdd},
        	function(data){
            	if(data==1){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	return false;
	           	}else{
				        $.messager.popover({msg: '修改失败！',type:'success',timeout: 1000});
	            		return false;
		        }
	 })
			}
		});		
	}else{
		 $.messager.alert('提示','请选择要启用的字典！','warning');
		 return;
	}			
}
//==================================================停用数据维护部分============================================================//
/// 页面DataGrid初始定义通用名
function InitSubDataList(){
						
	// 编辑格
	var texteditor={
		type: 'text',//设置编辑格式
		options: {
			required: true //设置编辑规则属性
		}
	}
	
	// 定义columns   
	var columns=[[   	 
			{field:'DataID',title:'DataID',hidden:true},
			{field:'dicID',title:'dicID',hidden:false},
			{field:'DataDesc',title:'描述',width:300},
			{field:'Function',title:'功能',width:100,align:'left',formatter: function(value,row,index){
				if (value=="stop")
				{
					return "停用";
					
				} else if(value=="confirm")
				{
					return "核实";	
				}else if(value=="enable")
				{
					return "复用"	
				}else
				{
					return value;	
				}
			}},
			{field:'DateTime',title:'操作日期',width:250,align:'left'},
			{field:'TimeTime',title:'操作时间',width:250,align:'left'},
			{field:'Scope',title:'作用域',width:250,align:'left',formatter: function(value,row,index){
				if (value=="U"){
					return "人员";
				} else if(value=="G")
				{
					return "安全组";
					
				}else if(value=="L")
				{
					return "科室"	
				}else if(value=="D")
				{
					return "全院"	
				}else if(value=="P")
				{
					return "职称"	
				}
			}},
			{field:'ScopeValue',title:'作用域值',width:250,align:'left'},
			{field:'UserID',title:'用户',width:250,align:'left',hidden:true},
			{field:'Operating',title:'操作',width:200,align:'center',formatter:SetCellOperation} 

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
	 		
	 		}, 
		onDblClickRow: function (rowIndex, rowData) {
            
        },
        onLoadSuccess:function(data){
            $('.mytooltip').tooltip({
            trackMouse:true,
            onShow:function(e){
              $(this).tooltip('tip').css({});
            }
          });          
        }	
		  
	}
	var uniturl = $URL+"?ClassName=web.DHCCKBWriteLog&MethodName=GetStopDataValue&DataID="+parref+"&flagValue"+flagValue;
	//var newurl = $URL+"?ClassName=web.DHCCKBWriteLog&MethodName=QueryStopByAuto&DataID="+parref;
	new ListComponent('subdiclist', columns, uniturl, option).Init();
	
}
/// sub插入新行
function SubInsertRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);		//结束编辑，传入之前编辑的行
	}
	$("#subdiclist").datagrid('insertRow', {
		index: 0, // 行数从0开始计算
		/* row: {ID:'', Code:'', Desc:'',Type:"",TypeDr:""} */
		row: {}
	});
	$("#subdiclist").datagrid('beginEdit', 0);				//开启编辑并传入要编辑的行
	editsubRow=0;
}

/// sub保存
function SubSaveRow(){
	
	if(editsubRow>="0"){
		$("#subdiclist").datagrid('endEdit', editsubRow);
	}

	var rowsData = $("#subdiclist").datagrid('getChanges');
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

		var tmp=$g(rowsData[i].ID) +"^"+ $g(rowsData[i].CDCode) +"^"+ $g(rowsData[i].CDDesc) +"^"+ parref;
		
		dataList.push(tmp);
	} 
	var params=dataList.join("&&");
	var attrData = "";

	//保存数据
	runClassMethod("web.DHCCKBDiction","SaveUpdateNew",{"params":params,"attrData":attrData,"LgUserID":LgUserID,"LgHospID":LgHospID},function(jsonString){
		if (jsonString >= 0){
			$.messager.alert('提示','保存成功！','info');
		}else if(jsonString == -98){
			$.messager.alert('提示','保存失败,代码重复！','warning');
			
		}else if(jsonString == -99){
			$.messager.alert('提示','保存失败,描述重复！','warning');

		}else{
			$.messager.alert('提示','保存失败！','warning');
		}
		SubQueryDicList(parref);		
		//$('#diclist').datagrid('reload'); //重新加载
	});
}

/// sub删除    sunhuiyong 2020-02-03 删除插入表中不真正删除 
function SubDelRow(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
		$.messager.confirm("提示", "您确定要停用这些数据吗？", function (res) {	// 提示是否删除
			if (res) {
				runClassMethod("web.DHCCKBDiction","UsedDic",{"dicID":rowsData.ID},function(jsonString){
					if (jsonString == 0){
						SetFlag="STDATA"        //停用数据标记
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid+"&ClientIP="+IP;
						window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
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

}
function reloadDatagrid(){
	$("#diclist").datagrid("reload");
	$("#subdiclist").datagrid("reload");
}
///核实 Sunhuiyong 2020-02-20
function AcDataFlag(){
	var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要删除的行
	if (rowsData != null) {
						SetFlag="ACDATA"        //核实数据标记
						DicName="DHC_CKBCommonDiction"
						dataid=rowsData.ID
						Operator=LgUserID
						//$HUI.dialog("#diclog").open();
						var link = "dhcckb.diclog.csp?DicName="+ DicName +"&Operator="+ LgUserID +"&SetFlag="+ SetFlag +"&dataid="+dataid;
						window.open(link,"_blank","height=400, width=650, top=200, left=400,toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
						}else{
		 $.messager.alert('提示','请选择要核实的项','warning');
		 return;
	}	
		
}
/// sub 查询
function SubQueryDicList(id){
	
	var params = $HUI.searchbox("#subQueryCode").getValue();
	
	$('#subdiclist').datagrid('load',{
		DataID:parref,
		parDesc:params,
		flagValue:flagValue
	}); 
}

// 重置
function InitSubPageInfo(){

	$HUI.searchbox('#subQueryCode').setValue("");
	SubQueryDicList();	

}

/// 字典分类树
function InitTree(){
	var url = "" //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	
	var url = $URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref 
	var option = {
		height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
		multiple: true,
		lines:true,
		checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		fitColumns:true,
		animate:true,
        onClick:function(node, checked){
	        var isLeaf = $("#dictree").tree('isLeaf',node.target);   /// 是否是叶子节点
	        if (isLeaf){
		        							   
	        }else{
		    	//$("#attrtree").tree('toggle',node.target);   /// 点击项目时,直接展开/关闭
		    }
	    },
	    onCheck:function(node,checked)
	    {
		    $(this).tree('select', node.target);
		},
	    onContextMenu: function(e, node){
			
			e.preventDefault();
			$(this).tree('select', node.target);
			var node = $("#dictree").tree('getSelected');
			if (node == null){
				$.messager.alert("提示","请选中节点后重试!"); 
				return;
			}
				
			// 显示快捷菜单
			$('#right').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
		},
	    onExpand:function(node, checked){
			var childNode = $("#dictree").tree('getChildren',node.target)[0];  /// 当前节点的子节点
			
	        var isLeaf = $("#dictree").tree('isLeaf',childNode.target);        /// 是否是叶子节点
	        if (isLeaf){
	        }
		}
	};
	new CusTreeUX("dictree", url, option).Init();
	//$('#CheckPart').tree('options').url = uniturl;
	//$('#CheckPart').tree('reload');		
}
/// 查询方法
function SearchData(){
	var desc=$.trim($("#FindTreeText").val());
	$("#dictree").tree("search", desc)
	//$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
}
/// 重置方法
function ClearData(){
	
	$("#FindTreeText").val("");
	$('#dictree').tree('reload')
	//$('#dictree').tree('uncheckAll');
	$('#dictree').find('.tree-node-selected').removeClass('tree-node-selected'); //取消树的节点选中
}
//点击添加子节点按钮
function AddDataTree() {
	RefreshData();
	var options={};
	options.url=$URL+"?ClassName=web.DHCCKBQueryDic&MethodName=GetTreeJson&parref="+parref
	$('#parref').combotree(options);
	$('#parref').combotree('reload')
	
	$("#myWin").show();
	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-addlittle',
		resizable:true,
		title:'添加',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'保存',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				SaveDicTree(1)
			}
		},{
			text:'继续添加',
			//iconCls:'icon-save',
			id:'save_btn',
			handler:function(){
				TAddDicTree(2)
			}
		},{
			text:'关闭',
			handler:function(){
				myWin.close();
			}
		}]
	});	
	
	var record =$("#dictree").tree('getSelected');
	
	if (record){
		//$("#treeID").val(record.id);
		//var parentNode=$("#dictree").tree("getParent",record.target)	
		//if (parentNode){	
		//alert(record.id)	
			$('#parref').combotree('setValue', $g(record.id));
		//}
	}
}
/// 清空数据
function RefreshData(){
	$("#treeID").hide();
	$("#treeID").val("");
	$("#treeCode").val("");
	$("#treeDesc").val("");
	$('#parref').combotree('setValue','');
};


///复用
function SetCellOperation(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='复用' onclick=\"ReUse('"+rowData.StopRowID+"','"+rowData.dicID+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 
    return btn; 
}
function ReUse(StopRowID,DicID){
		$.messager.confirm('确认对话框','确定复用该数据吗？', function(r){
		if (r){
				var OperateDate=SetDateTime("date");
				var OperateTime=SetDateTime("time");
				var SetFlag="enable"    //复用数据标记
				var DicName="DHC_CKBCommonDiction"
				//runClassMethod("web.DHCCKBWriteLog","ReUseData",{"StopRowID":StopRowID,"DicID":DicID,"LgUserID":LgUserID,"OperateDate":OperateDate,"OperateTime":OperateTime,"ClientIPAddress":ClientIPAdd},   Sunhuiyong 2020-04-08 修改为公共方法-复用
      runClassMethod("web.DHCCKBWriteLog","InsertDicLog",{"DicDr":DicName,"dataDr":DicID,"Function":SetFlag,"Operator":LgUserID,"OperateDate":OperateDate,"OperateTime":OperateTime,"Scope":"","ScopeValue":"","ClientIPAddress":ClientIPAdd,"Type":"log"},
        	function(data){
            	if(data==0){
	            	$.messager.popover({msg: '修改成功！',type:'success',timeout: 1000});
	            	$("#subdiclist").datagrid('reload');
	            	return false;
	           	}else{
				        $.messager.popover({msg: '修改失败！',type:'success',timeout: 1000});
	            		return false;
		        }
	 })
		}
	});

	}
function SetDateTime(flag)
{
	var result=""
	runClassMethod("web.DHCCKBWriteLog","GetDateTime",{"flag":flag},function(val){	
	  result = val
	},"text",false)
	return result;
}

/// 初始化tabs中的数据表格
function SetTabsInit(){

	var AddextraAttrValue = "AttrFlag" 	// knowledge-属性
	// 属性
	var myAttrTree = $HUI.tree("#attrtree",{
		url:"", //$URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue,
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  //是否级联检查。默认true  菜单特殊，不级联操作
		animate:false     	//是否树展开折叠的动画效果		
	});
	
	var AddextraAttrValue = "DictionFlag" 	// knowledge-属性
	// 属性
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	var DicTree = $HUI.tree("#dicextratree",{
		url:uniturl, 
   		lines:true,  //树节点之间显示线条
		autoSizeColumn:false,
		//checkbox:true,
		checkOnSelect : true,
		cascadeCheck:false,  		//是否级联检查。默认true  菜单特殊，不级联操作
		animate:false,    			//是否树展开折叠的动画效果
		onClick:function(node, checked){
	    	
	    },
	    onLoadSuccess: function(node, data){
			if (node != null){
					$('#dicextratree').tree('expand', node.target);
			}
		}
			
	}); 
	
	// 字典
	var diccolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left'},
			{field:'CDDesc',title:'描述',width:300,align:'left'}			
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
		pageList:[30,60,90]	
		  
	}
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('dicgrid', diccolumns, uniturl, option).Init();
  
    // 实体
	var entitycolumns=[[   	 
			{field:'ID',title:'rowid',hidden:true},
			{field:'CDCode',title:'代码',width:200,align:'left'},
			{field:'CDDesc',title:'描述',width:300,align:'left'}			
		 ]]
	var uniturl = "" //$URL+"?ClassName=web.DHCCKBDiction&MethodName=GetDicListByAttrCode&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue+"&params=";
	new ListComponent('entitygrid', entitycolumns, uniturl, option).Init();

}
/// 保存
function SaveFunLib(){

	var currTab = $('#tabOther').tabs('getSelected');
	var currTabTitle = currTab.panel('options').title;
	var selectID=""
	var selectDesc=""
	
	
	if (currTabTitle.indexOf("属性")!=-1){					// 选择属性
		var attrrow = $('#attrtree').tree('getSelected');	// 获取选中的行  
		selectID = $g(attrrow)==""?"":attrrow.id;
		selectDesc =  $g(attrrow)==""?"":attrrow.code;
		
	}else if(currTabTitle.indexOf("字典") != -1){				// 选择字典
	
		var dicrow =$('#dicextratree').tree('getSelected');	// 获取选中的行
		selectID = $g(dicrow)==""?"":dicrow.id;
		selectDesc =  $g(dicrow)==""?"":dicrow.code;
		
	}else if(currTabTitle.indexOf("实体") != -1){				// 选择实体
	
		var entityrow =$('#entitygrid').datagrid('getSelected'); // 获取选中的行  
		selectID = $g(entityrow)==""?"":entityrow.ID;
		selectDesc =  $g(entityrow)==""?"":entityrow.CDDesc;
	}

	if ($g(selectID) == ""){	
		 $.messager.alert('提示','请选择一个属性或字典或实体！','info');
		 return;	
	} 
	
	/// 附加属性界面赋值
	$('#addattrlist').datagrid('beginEdit', editaddRow);	
	//var attrDescObj=$("#addattrlist").datagrid('getEditor',{index:editRow,field:'DLAAttrDesc'});
	//$(attrDescObj.target).val(selectDesc);
	var attrDrObj=$("#addattrlist").datagrid('getEditor',{index:editaddRow,field:'DLAAttrDr'});
	$(attrDrObj.target).val(selectID);
	$('#addattrlist').datagrid('endEdit', editaddRow);
	saveRowAddAttr();

	//$HUI.dialog("#myWin").close();
}
///保存
function saveRowAddAttr()
{
	// 使用此方法保存时，需要datagrid的列名和表字段名称相同，修改时ID默认固定
	comSaveByDataGrid("User.DHCCKBDicLinkAttr","#addattrlist",function(ret){
			if(ret=="0")
			{
				$('#AttrWin').dialog('close');
				$("#addattrlist").datagrid('reload');
				QueryDicList();
			}
					
		}
	)	
}
//属性树的刷新
function AttrRefreshData()
{
	$HUI.searchbox("#attrtreecode").setValue("");
	var searcode=$HUI.searchbox("#attrtreecode").getValue();
	var AddextraAttrValue = "AttrFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///检索属性树
function findattrTree(searcode)
{
	var extraAttrValue = "AttrFlag" 	// 字典标记(附加属性值)
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+extraAttrValue;
	$("#attrtree").tree('options').url =encodeURI(uniturl);
	$("#attrtree").tree('reload');
}
///检索字典树
function finddicTree(searcode)
{
	var AddextraAttrValue = "DictionFlag" 	// 字典标记(附加属性值)
	if(searcode==""){
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	}else{
		var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryProTreeListByAttrCode&params='+searcode+"&parref=&extraAttr="+extraAttr+"&extraAttrValue="+AddextraAttrValue;
	}
	$("#dicextratree").tree('options').url =encodeURI(uniturl);
	$("#dicextratree").tree('reload');
}
///属性清屏
function Refreshdic()
{
	$HUI.searchbox("#dictreecode").setValue("");
	var AddextraAttrValue = "DictionFlag"
	var uniturl = $URL+'?ClassName=web.DHCCKBDiction&MethodName=QueryDicTree&id=0'+'&extraAttr='+extraAttr+'&extraAttrValue='+AddextraAttrValue;
	$("#dicextratree").tree('options').url =encodeURI(uniturl);
	$("#dicextratree").tree('reload');
}
// 实体查询
function QueryWinDicList()
{
	var params = $HUI.searchbox("#entityCode").getValue();
	var AddextraAttrValue="ModelFlag";
	$('#entitygrid').datagrid('load',{
		extraAttr:extraAttr,
		extraAttrValue:AddextraAttrValue,
		params:params
	}); 
}
function InitPageInfoWin()
{
	$HUI.searchbox("#entityCode").setValue("");
	QueryWinDicList();
}
/// 删除
function DelLinkAttr(){

	removeCom("User.DHCCKBDicLinkAttr","#addattrlist")
}
///刷新datagrid
function reloadPagedg()
{
	$("#diclist").datagrid("reload");    
}
//重置字典指向按钮-tree
function ResettreeParref()
{
var node=$("#dictree").tree('getSelected');//选中要修改的行
	if (node != null) {
		$HUI.dialog("#resetparref").open();
	/// 初始化combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //选择指向字典id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("newparrefid",url,'',option).init(); 
	}else{
		 $.messager.alert('提示','请选择要修改的元素！','warning');
		 return;		
}		
}
///重置字典指向按钮-datagrid
function ResetParref()
{
var rowsData = $("#subdiclist").datagrid('getSelected'); //选中要修改的行
	if (rowsData != null) {
		$HUI.dialog("#resetparref").open();
	/// 初始化combobox
	var option = {
		//panelHeight:"auto",
		mode:"remote",
		valueField:'value',
		textField:'text',		
        onSelect:function(option){
        dicParref = option.value;  //选择指向字典id
	    }
	}; 
	var url = LINK_CSP+"?ClassName=web.DHCCKBDiction&MethodName=GetDicComboboxList&extraAttr="+extraAttr +"&extraAttrValue="+extraAttrValue;
	new ListCombobox("newparrefid",url,'',option).init(); 
	}else{
		 $.messager.alert('提示','请选择要修改的元素！','warning');
		 return;		
}
}




/// JQuery 初始化页面
$(function(){ initPageDefault(); })
