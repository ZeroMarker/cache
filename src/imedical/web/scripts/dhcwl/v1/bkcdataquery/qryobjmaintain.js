var curProgress="";
var dataSrcObj=null;//保存数据源obj
var OldDataSrcObj=null;

	var delItem=function (gridSelector,ID) {
		$.messager.confirm("删除", "确定删除并保存?", function (r) { 
			if (r) {                                                 
				//$.messager.popover({msg:"点击了确定",type:'info'}); 
				var index=$(gridSelector).datagrid("getRowIndex",ID);
				var row=$(gridSelector).datagrid('getRows')[index];
				$cm({
					ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
					MethodName:"DelQryItem",
					wantreturnval:0,
					itemID:row.ID
				},function(jsonData){
						//$.messager.alert("提示",jsonData.msg);
						if (jsonData.success==0) {
							$.messager.alert("提示","数据库删除失败,"+jsonData.msg);
						}else{
							editIndex=undefined;
							$(gridSelector).datagrid("reload");
						}
				});						   
			} else {                                                 
				//$.messager.popover({msg:"点击了取消"});                
			}                                                        
		});  		
	

	};

	
	/////////////////////////////////////////////////////////////////////
	///gridSelector='#propertygrid'
	var editIndex=undefined;
	var modifyBeforeRow = {};
	var modifyAfterRow = {};
	///编辑ITEM
	var editItem=function (gridSelector,ID,updateFun) {
		
		var index=$(gridSelector).datagrid("getRowIndex",ID);
		//alert("editItem "+inx);	
		if (editIndex != index){
			//if (endEditing(gridSelector,index,updateFun)){
			if (endEditing(gridSelector,ID,updateFun)){
				$(gridSelector).datagrid('selectRow', index).datagrid('beginEdit', index);
				editIndex = index;
				modifyBeforeRow = $.extend({},$(gridSelector).datagrid('getRows')[editIndex]);
			} else {
				$(gridSelector).datagrid('selectRow', editIndex);
			}
		}		
	};
	///结束编辑
	function endEditing(gridSelector,ID,updateFun){
		var index=$(gridSelector).datagrid("getRowIndex",ID);
		
		if (editIndex == undefined){return true}
		if ($(gridSelector).datagrid('validateRow', editIndex)){
			$(gridSelector).datagrid('endEdit',editIndex);
			
			modifyAfterRow = $(gridSelector).datagrid('getRows')[editIndex];
			var aStr = JSON.stringify(modifyAfterRow);
			var bStr = JSON.stringify(modifyBeforeRow);
			if(aStr!=bStr){
				/*console.log('修改前：');
				console.dir(modifyBeforeRow);
				console.log('修改后：');
				console.dir(modifyAfterRow);
				*/
				if (!!updateFun){
					updateFun(gridSelector,editIndex);
				}
			}
			editIndex = undefined;
			return true;                                                                                
		} else {
			return false;                                                                               
		}                                                                                             
	} 
	
	///编辑完成后，更新后台数据 	
	var updateItem=function(gridSelector,inx){
		$.messager.confirm("保存", "保存修改的数据吗?", function (r) {
			if (r) {
				var rowData=$(gridSelector).datagrid('getRows')[inx];
				var itemData=rowData.ID+"^"+rowData.Name+"^"+rowData.Descript;
				$cm({
					ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
					MethodName:"UpdateQryItem",
					wantreturnval:0,
					itemData:itemData
				},function(jsonData){
						//$.messager.alert("提示",jsonData.msg);
						if (jsonData.success==0) {
							$.messager.alert("提示","数据库更新失败"+jsonData.msg);
						}
				});
				$(gridSelector).datagrid('reload');
	
			}else {
				$(gridSelector).datagrid('reload');
			}		
		})
	}
	
	var cfgItem=function(gridSelector,ID){
		
		var inx=$(gridSelector).datagrid("getRowIndex",ID);
		
		var rowData=$(gridSelector).datagrid('getRows')[inx];
		showAddAggDlg(rowData);
		showAddAggDlg.curCfgData=rowData;
	}

	var showAddAggDlg=function(fillData){
		var title="新增聚合";
		if (!!fillData.Code) title="配置聚合";
		$HUI.dialog("#qryitem-addAggDlg",{
			title:title,
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			position: ['center','center'],
			autoOpen: false,			
			buttons:[{
				//id:'btnPrevID',
				text:'确定',
				handler:OnAddAggConfirm
			},{
				//id:'btnNextID',
				text:'取消',
				handler:OnAddAggCancel
			}]
			});	
			
		var url=$URL+"?ClassName=web.DHCWL.V1.BKCDQry.BaseDataServ&MethodName=GetSysMetrics&qryObjID="+curQryObj.ID;

	 	var SysMetrics=$HUI.combobox('#SysMetrics',{
			valueField:'Code',     
			textField:'Name',    
			method:'get',               
			url:url,
			required:true,
			editable:false

	 	});
	 	//充填数据
	 	if (!!fillData){
			 	if (!!fillData.Exp) {
				var strExp=fillData.Exp.toString();
				var aryExp=strExp.split("^");
				var expObj={};
				for(var j=0;j<aryExp.length;j++) {
					var k=aryExp[j].split(":")[0];
					var v=aryExp[j].split(":")[1];
					expObj[k]=v;
				}						
				$.extend( fillData, expObj );
		 	}		 	
		 	setFieldValues("addAggForm",fillData);
		 	
	 	}
	 	$('#qryitem-addAggDlg').dialog('open');
	 };
	 
	 
	function OnAddAggConfirm() {
		//1、数据格式校验
		flag = $("#addAggForm").form("validate");   //表单内容合法性检查
		if (!flag){
			myMsg("请按照提示填写信息");
			return;
		}
		//2、判断编码是否重复
		var values=getFieldValues("addAggForm");
		var Code=values.Code;
		if (!showAddAggDlg.curCfgData){
			var rowDatas=$("#modifyItemGrid").datagrid("getData");
			if (rowDatas.total>0) {
				for(var i=0;i<rowDatas.rows.length;i++){
					if(rowDatas.rows[i].Code==Code) {
						$.messager.alert("提示","录入的编码与已有的编码重复！请修改编码后再试。");
						return;
					}
					
				}
				
			}
		}
		
		//3、保存。数据类型选择number
		var Name=values.Name;
		var Descript=values.Descript;
		var Exp="AggFun:"+values.AggFun+"^SysMetrics:"+values.SysMetrics;
		var MethodName="saveCustomMetrics";
		var itemID="";
		if (!!showAddAggDlg.curCfgData) {
			itemID=showAddAggDlg.curCfgData.ID;
		}
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:MethodName,
			wantreturnval:0,
			/// 编码
			code:Code,
			/// 名称
			name:Name,
			/// 描述
			descript:Descript,
			/// 表达式
			exp:Exp,
			///查询对象ID
			qryObjID:curQryObj.ID,
			itemID:itemID

		},function(jsonData){
				if (jsonData.success==1) {
					$('#qryitem-addAggDlg').dialog('close');
					$.messager.alert("提示","操作成功！");
					$("#modifyItemGrid").datagrid("reload");
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
		});		
				
	};
	function OnAddAggCancel() {
		$('#qryitem-addAggDlg').dialog('close');
	};		 

var curQryObj;
var showDetail=function(ID){
	var data=$('#mainShowGrid').datagrid('getData');
	
	var inx=$('#mainShowGrid').datagrid("getRowIndex",ID);
	
	var row=data.rows[inx];
	var qryObjID=row.ID;
	curQryObj=row;

	editIndex=undefined;
	modifyBeforeRow = {};
	modifyAfterRow = {};

	////////////////////////////////////////////////////////////////////////////////
	///修改明细对话框
	$HUI.dialog("#qryObj-showItemDlg",{
		iconCls:'icon-w-paper',
		resizable:false,
		modal:true,
		position: ['center','center'],
		autoOpen: false
		/*,
		buttons:[{
			text:'关闭',
			handler:function(){
				$('#qryObj-showItemDlg').dialog('close');
			}			
		}]
		*/
	});	
	
	var modifyItemGrid = $HUI.datagrid("#modifyItemGrid",{
		//height:200,
		idField:'Code',
		fit:true,
		url:$URL,
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"GetQryItems",
			QryObjID:qryObjID,
			wantreturnval:0
		},
		columns:[[
			{field:'ID',title:'ID',width:180,align:'left',hidden:true},
			{field:'Code',title:'编码',width:180,align:'left'},
			{field:'Name',title:'名称',width:150,align:'left',editor:'text'},
			{field:'Descript',title:'描述',width:150,align:'left',editor:'text'},
			{field:'Type',title:'类型',width:70,align:'left'},
			{field:'CreateType',title:'创建类型',width:80,align:'left'},
			{field:'DataType',title:'数据类型',width:100,align:'left'},
			{field:'Exp',title:'表达式',width:100,align:'left',hidden:true},
			{field:'actOperation',title:'操作',width:80,align:'left',
				formatter:function(value,row,index){
					var selector="'#modifyItemGrid'";
					var rowdataid="\'"+row.Code+"\'";		//datagrid的idField；

					if(row.CreateType=="自定义") {
						var s = '<a href="#" title="修改" class="hisui-tooltip" ><span class="icon icon-write-order"  onclick="editItem('+selector+','+rowdataid+',updateItem)">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href="#" title="配置" class="hisui-tooltip" ><span class="icon icon-emr-cri"  onclick="cfgItem('+selector+','+rowdataid+')">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href="#" title="删除" class="hisui-tooltip" ><span class="icon icon-cancel"  onclick="delItem('+selector+','+rowdataid+')">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>';
						return s;
					}else{
						var s = '<a href="#" title="修改" class="hisui-tooltip" ><span class="icon icon-write-order"  onclick="editItem('+selector+','+rowdataid+',updateItem)">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>';
						return s;
					}
				} 
			}
	    ]],

		///pagination:true,
		///pageSize:1000,
	    ///pageList:[1000],
		fitColumns:true,
		onClickRow:	function(inx){
			//结束编辑
			if (editIndex != undefined && editIndex != inx){
				var Code=$("#modifyItemGrid").datagrid("getData").rows[inx].Code;
				endEditing("#modifyItemGrid",Code,updateItem);
				$("td.datagrid-value-changed").removeClass("datagrid-value-changed");
			}
		}
	});				
		
	///主界面查询响应方法
	$('#searchmodifyItem').searchbox({
		searcher:function(value){
			var gridData=$('#modifyItemGrid').datagrid('getData');
			var len=gridData.total;
			var curRowInx=0;
			var selRow=$('#modifyItemGrid').datagrid('getSelected');
			if (!!selRow) {
				var rowInx=$('#modifyItemGrid').datagrid('getRowIndex',selRow);
				if (rowInx>=0) curRowInx=rowInx+1;
				if (rowInx==len-1) curRowInx=0;
				
			}
			var stopflag=0;
			var nextSelInx=0;
			for(var i=0;i<len;i++){
				var rec=null;
				if (curRowInx<len) {
					rec=gridData.rows[curRowInx];
					nextSelInx=curRowInx;
				}else{
					rec=gridData.rows[curRowInx-len];
					nextSelInx=curRowInx-len;
				}
				for (x in rec) {
					if (rec[x].indexOf(value)>=0)  {
						$('#modifyItemGrid').datagrid('selectRow',nextSelInx);
						stopflag=1;
						break;
					}
				}
				curRowInx++;					

				if (stopflag==1) break;						
			}
		}
	});
	
	//如果是指标类的查询对象，需要隐藏“增加聚合项”的按钮

	if (curQryObj.DSType=="指标"){
		$("#qryitem-addAggBtn").attr("style","display:none;");
	}else{
		$("#qryitem-addAggBtn").attr("style","display:inline-block;");
	}

	$('#searchmodifyItem').searchbox("setValue","");
	$('#qryObj-showItemDlg').dialog('open');

	
};


var init = function(){
	////////////////////////////////////////////////////////
	///
	var proObj={
		theme:{},
		kpi:{}
	};

	proObj.kpi.UpdateProgress=function(curProgress) {
		if  (curProgress=="second" ) {
			//第1步的页面
			$("#ConfigForm").attr("style","display:none;");
			//主题属性页面
			$("#propertyPanel").hide();
			//信息汇总页面			
			$("#summaryPanel").hide();
			//增加指标页面
			$("#addKpiDiv").attr("style","display:block;");
			
			$("#addKpiDiv").layout('resize');
			//$('#qryObj-addDlg').dialog("maximize");

			if (dataSrcObj != OldDataSrcObj) {
				OldDataSrcObj=dataSrcObj;
				
				var browseKpiGrid = $HUI.datagrid("#browseKpiGrid",{
					title:'可选指标',
					height:$("#browseKpiPanel").height(),
					width:$("#browseKpiPanel").width(),	
					idField:'Code',
					url:$URL,
					queryParams:{
						ClassName:"web.DHCWL.V1.BKCDQry.KPIDataServ",
						searchV:"",
						QueryName:"GetKpiInfo",
						exceptKpi:"",
						incDimCodes:""				
					},
					columns:[[
						{field:'ID',title:'ID',width:50,align:'left',hidden:true},
						{field:'Code',title:'编码',width:150,align:'left'},
						{field:'Name',title:'名称',width:150,align:'left'},
						{field:'DimCodes',title:'维度编码',width:70,align:'left',hidden:true},
						{field:'DimDescs',title:'维度描述',width:150,align:'left'}
				    ]],
		    		pagination:true,
					pageSize:50,
				    pageList:[15,20,50,100],
					fitColumns:true,
					onDblClickRow:function(inx,rowData){
						$("#kpiGrid").datagrid("appendRow",rowData)
						RefreshDimGrid();
						var searchV=$('#searchBrowseKpiGrid').searchbox("getValue");
						RefreshBrowseKpi(searchV);
					}}
				);
				
				
				$('#searchBrowseKpiGrid').searchbox({
					searcher:function(value){
						RefreshBrowseKpi(value);
						
					}
				});
				
				
				var kpiGrid = $HUI.datagrid("#kpiGrid",{
					toolbar: [] ,
					title:'已选指标',
					height:$("#kpiPanel").height(),
					width:$("#kpiPanel").width(),	
					idField:'Code',
					columns:[[
						{field:'ID',title:'ID',width:50,align:'left',hidden:true},
						{field:'Code',title:'编码',width:150,align:'left'},
						{field:'Name',title:'名称',width:150,align:'left'}
				    ]],
					fitColumns:true,
					onDblClickRow:function(inx,rowData){
						$("#kpiGrid").datagrid("deleteRow",inx)
						RefreshDimGrid();
						var searchV=$('#searchBrowseKpiGrid').searchbox("getValue");
						RefreshBrowseKpi(searchV);
					}}
				);				
				
				var dimGrid = $HUI.datagrid("#dimGrid",{
					toolbar: [] ,
					title:'指标维度',
					height:$("#dimPanel").height(),
					width:$("#dimPanel").width(),	
					idField:'Code',
					columns:[[
						//{field:'ID',title:'ID',width:50,align:'left',hidden:true},
						{field:'Code',title:'编码',width:150,align:'left'},
						{field:'Name',title:'名称',width:150,align:'left'}
				    ]],
					fitColumns:true,
					onClickRow:	function(inx){

					}}
				);		
				
				
				var RefreshDimGrid=function() {
					var dimsObj=null;
					var kpiData=$("#kpiGrid").datagrid("getData");
					for(var i=0;i<kpiData.rows.length;i++) {
						var dimCs=kpiData.rows[i].DimCodes;
						var dimDs=kpiData.rows[i].DimDescs;
						
						var aryDimCs=dimCs.split(",");
						var aryDimDs=dimDs.split(",");
						var kDim={};
						for(var j=0;j<aryDimCs.length;j++) {
							var dimC=aryDimCs[j];
							kDim[dimC]={"desc":aryDimDs[j]};
						}
						if (dimsObj==null) {
							dimsObj=kDim;
						}else{
							var newDimObj={};
							for(var x in dimsObj) {
								if (kDim[x]) newDimObj[x]=dimsObj[x];
							}
							
							dimsObj=newDimObj;
						}
					}
					
					var rowData=[];
					for (var x in dimsObj) {
						var o={};
						o.Code=x;
						o.Name=dimsObj[x].desc;
						rowData.push(o);
					}
					

					$("#dimGrid").datagrid("loadData",rowData);

					
				}
				
				var RefreshBrowseKpi=function(searchV){

					var kpiData=$("#kpiGrid").datagrid("getData");
					var kpiIDs="";
					for(var i=0;i<kpiData.rows.length;i++) {
						if (kpiIDs=="") {
							kpiIDs=kpiData.rows[i].ID;
						}else{
							kpiIDs=kpiIDs+","+kpiData.rows[i].ID;
						} 
					}

					var dimData=$("#dimGrid").datagrid("getData");
					var dimCodes="";
					for(var i=0;i<dimData.rows.length;i++) {
						if (dimCodes=="") {
							dimCodes=dimData.rows[i].Code;
						}else{
							dimCodes=dimCodes+","+dimData.rows[i].Code;
						} 
					}
					
					browseKpiGrid.reload(
					{
						ClassName:"web.DHCWL.V1.BKCDQry.KPIDataServ",
						searchV:searchV,
						QueryName:"GetKpiInfo",
						exceptKpi:kpiIDs,
						incDimCodes:dimCodes				

					});
										
					
				}	
			}
			$('#btnPrevID').linkbutton("enable");
			$("#btnNextID").html("<span class=\"l-btn-left\"><span class=\"l-btn-text\">下一步</span></span>")			
		}else if(curProgress=="end" ) {
			$("#ConfigForm").attr("style","display:none;");
			$("#summaryPanel").hide();
			$("#addKpiDiv").attr("style","display:none;");
			//主题属性页面
			$("#propertyPanel").hide();
			
			
			//$('#qryObj-addDlg').dialog("restore");			

			$('#btnPrevID').linkbutton("enable");
			$("#btnNextID").html("<span class=\"l-btn-left\"><span class=\"l-btn-text\">完&nbsp;&nbsp;&nbsp;成</span></span>")	
			var html=proObj.kpi.getSummary(dataSrcObj);
			//$('#qryObj-addDlg').dialog("restore");		
			$("#summaryPanel").html(html);
			$("#summaryPanel").show();
			//$("#summaryPanel").height($("#qryObj-addDlg").height()-30);
			//$("#summaryPanel").width($("#qryObj-addDlg").width()-15);
		}
	};
	
	proObj.kpi.OnPrev=function(){
		if (curProgress=="second"){
			curProgress="start";
		}else if  (curProgress=="end" ) {
			curProgress="second";
		}
	};

	proObj.kpi.OnNext=function() {
		if  (curProgress=="second" ) {
			curProgress="end";
		}else if  (curProgress=="end" ) {
			proObj.kpi.SaveConfig();
		}		
	};
	
	proObj.kpi.getSummary=function() {
		var values=getFieldValues("ConfigForm");

		var html=[];
		html.push('<br/>');
		html.push('<br/>');
		html.push('<br/>');
		html.push('<p align="center">查询对象配置概要</p>');
		html.push('<br/>');
		html.push('<br/>');

		html.push('<div style="padding:0 0 0 20px;line-height: 24px;">');
			html.push('<p>编码：'+ values.Code   +'  </p>');
			html.push('<p>名称：'+ values.Name   +'  </p>');
			html.push('<p>描述：'+ values.Description   +'  </p>');	
			html.push('<p>数据源编码：'+ dataSrcObj.Code   +'  </p>');
			html.push('<p>数据源类型：'+ dataSrcObj.Type   +'  </p>');	
			
			html.push('<p>指标： </p>');	
				html.push('<div style="padding:0 0 0 20px;line-height: 24px;">');
					//指标:指标编码-指标描述
					//维度:维度编码-维度描述
					var kpiData=$("#kpiGrid").datagrid("getData");
					var kpiIDs="";
					for(var i=0;i<kpiData.rows.length;i++) {
						var kpiInfo=kpiData.rows[i].Code+"-"+kpiData.rows[i].Name;
						html.push('<p>'+kpiInfo+'</p>');
					}
				html.push('</div>');
			html.push('<p>维度：</p>');
				html.push('<div style="padding:0 0 0 20px;line-height: 24px;">');
					var dimData=$("#dimGrid").datagrid("getData");
					var dimCodes="";
					for(var i=0;i<dimData.rows.length;i++) {
						dimCodes=dimData.rows[i].Code+"-"+dimData.rows[i].Name;
						html.push('<p>'+dimCodes+'</p>');
					}		
				html.push('</div>');
		html.push('</div>');	
		return html.join('');
	}	
	
//保存配置
	proObj.kpi.SaveConfig=function() {
		var values=getFieldValues("ConfigForm");
		var qryObjCode=values.Code;
		var qryObjName=values.Name;
		var QryObjDesc=values.Description;
		var qryObjDSID=dataSrcObj.ID;
		
		//统计项编码		
		var itemCodes=[]
		//统计项名称
		var itemNames=[]
		//统计项描述
		var itemDescripts=[]
		//统计项类型：维度，度量
		var itemTypes=[]
		//统计项创建类型：系统，自定义
		var itemCreateT=[]
		//统计项表达式
		var itemExps=[]
		//统计项数据类型：NUMERIC-数值；VARCHAR-字符串
		var itemDataTypes=[];
		
		
		var kpiData=$("#kpiGrid").datagrid("getData");
		for(var i=0;i<kpiData.rows.length;i++) {
			itemCodes.push(kpiData.rows[i].Code); 
			itemNames.push(kpiData.rows[i].Name); 
			itemDescripts.push(kpiData.rows[i].Name); 
			itemTypes.push("度量"); 
			itemCreateT.push("系统"); 
			itemExps.push(""); 
			itemDataTypes.push("NUMERIC");			
		}		
		var dimData=$("#dimGrid").datagrid("getData");
		for(var i=0;i<dimData.rows.length;i++) {
			itemCodes.push(dimData.rows[i].Code); 
			itemNames.push(dimData.rows[i].Name); 
			itemDescripts.push(dimData.rows[i].Name); 
			itemTypes.push("维度"); 
			itemCreateT.push("系统"); 
			itemExps.push(""); 
			itemDataTypes.push("VARCHAR");
		}

		var items=itemCodes.join("^")+String.fromCharCode(2)+itemNames.join("^")+String.fromCharCode(2);
		items=items+itemDescripts.join("^")+String.fromCharCode(2)+itemTypes.join("^")+String.fromCharCode(2);
		items=items+itemCreateT.join("^")+String.fromCharCode(2)+itemExps.join("^")+String.fromCharCode(2)+itemDataTypes.join("^");
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"InsertQryObj",
			wantreturnval:0,
			QryObj:qryObjCode+"^"+qryObjName+"^"+QryObjDesc+"^"+qryObjDSID,
			QryItems:items
		},function(jsonData){
				$.messager.alert("提示",jsonData.msg);
				if (jsonData.success==1) {
					$('#qryObj-addDlg').dialog('close');




					$('#mainShowGrid').datagrid('reload',{
						ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
						MethodName:"GetBDQObj",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
						searchV:"",
						wantreturnval:0
					});
					
				}
			
		});		
		
	}		
	
	proObj.theme.UpdateProgress=function(curProgress) {
		if  (curProgress=="second" ) {
			//第1步的页面
			$("#ConfigForm").attr("style","display:none;");
			//信息汇总页面	
			$("#summaryPanel").hide();
			//$('#qryObj-addDlg').dialog("maximize");
			//主题属性页面
			$("#propertyPanel").height("100%");			
			$('#propertyPanel').show();
			//增加指标页面
			$("#addKpiDiv").attr("style","display:none;");
			
			if (dataSrcObj != OldDataSrcObj) {
				OldDataSrcObj=dataSrcObj;
				
			var propertyGrid = $HUI.datagrid("#propertygrid",{
				height:$("#propertyPanel").height(),	
				idField:'Code',
				url:$URL,
				
				queryParams:{
					ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
					QueryName:"QryDSFields",
					DSID:dataSrcObj.ID,
					rows:1000
				},
				
				columns:[[
					{field:'Code',title:'编码',width:180,align:'left'},
					{field:'Name',title:'名称',width:150,align:'left',editor:'text'},
					{field:'Descript',title:'描述',width:150,align:'left',editor:'text'},
					{field:'Type',title:'类型',width:70,align:'left'},
					{field:'CreateType',title:'创建类型',width:80,align:'left'},
					{field:'DataType',title:'数据类型',width:80,align:'left'},
					{field:'Exp',title:'表达式',width:100,align:'left'},
					{field:'action1',title:'操作',width:70,align:'left',
						formatter:function(value,row,index){
							var selector="'#propertygrid'";
							var rowdataid="\'"+row.Code+"\'";
							if(row.CreateType=="自定义") {
								//var s = '<a href="#" title="编辑" class="hisui-tooltip" ><span class="icon icon-edit"  onclick="editItem('+selector+','+rowdataid+',null)">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href="#" title="配置" class="hisui-tooltip" ><span class="icon icon-emr-cri"  onclick="cfgItem('+rowdataid+')">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href="#" title="删除" class="hisui-tooltip" ><span class="icon icon-remove"  onclick="delItem('+rowdataid+')">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>';
								//return s;
							}else{
								var s = '<a href="#" title="修改" class="hisui-tooltip" ><span class="icon icon-write-order"  onclick="editItem('+selector+','+rowdataid+',null)">&nbsp;&nbsp;&nbsp;&nbsp;</span></a>';
								return s;
							}
						}					
					}
			    ]],
			    
	    		//pagination:true,
				//pageSize:1000,
			    //pageList:[1000],
				
				fitColumns:true,
				onClickRow:	function(inx){
					//结束编辑
					if (editIndex != undefined && editIndex != inx){
						endEditing("#propertygrid",inx,null);
					}
				}
			});				
			}			

			$('#btnPrevID').linkbutton("enable");
			$("#btnNextID").html("<span class=\"l-btn-left\"><span class=\"l-btn-text\">下一步</span></span>")		

		}else if  (curProgress=="end" ) {
			$("#ConfigForm").attr("style","display:none;");
			$('#propertyPanel').hide();
			$('#btnPrevID').linkbutton("enable");
			$("#btnNextID").html("<span class=\"l-btn-left\"><span class=\"l-btn-text\">完&nbsp;&nbsp;&nbsp;成</span></span>")	
			var html=proObj.theme.getSummary(dataSrcObj);
			$("#summaryPanel").html(html);
			$("#summaryPanel").show();
			//$('#qryObj-addDlg').dialog("restore");
		}
	};

	proObj.theme.OnPrev=function(){
		if (curProgress=="second"){
			curProgress="start";
		}else if  (curProgress=="end" ) {
			curProgress="second";
		}
	};

	proObj.theme.OnNext=function() {
		if  (curProgress=="second" ) {
			curProgress="end";
		}else if  (curProgress=="end" ) {
			proObj.theme.SaveConfig();
		}		
	};
	proObj.theme.getSummary=function() {
		var values=getFieldValues("ConfigForm");

		var html=[];
		html.push('<br/>');
		html.push('<br/>');
		html.push('<br/>');
		html.push('<p align="center">查询对象配置概要</p>');
		html.push('<br/>');
		html.push('<br/>');
		html.push('<div style="padding:0 0 0 20px;line-height: 24px;">');
				html.push('<p>编码：'+ values.Code   +'  </p>');
				html.push('<p>名称：'+ values.Name   +'  </p>');
				html.push('<p>描述：'+ values.Description   +'  </p>');	
				html.push('<p>数据源编码：'+ dataSrcObj.Code   +'  </p>');
				html.push('<p>数据源类型：'+ dataSrcObj.Type   +'  </p>');						
		html.push('</div>');
		html.push('<br/>');

		return html.join('');
	}	
	
	//保存配置
	proObj.theme.SaveConfig=function() {
		var values=getFieldValues("ConfigForm");
		var qryObjCode=values.Code;
		var qryObjName=values.Name;
		var QryObjDesc=values.Description;
		var qryObjDSID=dataSrcObj.ID;
		
		
		var propertyData=$('#propertygrid').datagrid("getData");
		var len=propertyData.total;
				
		var itemCodes=[],itemNames=[],itemDescripts=[],itemTypes=[],itemCreateT=[],itemExps=[],itemDataTypes=[];
		
		for(var i=0;i<len;i++){
			var rec=propertyData.rows[i];
			itemCodes.push(rec.Code); 
			itemNames.push(rec.Name); 
			itemDescripts.push(rec.Descript); 
			itemTypes.push(rec.Type); 
			itemCreateT.push(rec.CreateType); 
			itemExps.push(rec.Exp); 
			itemDataTypes.push(rec.DataType); 
		};
		var items=itemCodes.join("^")+String.fromCharCode(2)+itemNames.join("^")+String.fromCharCode(2);
		items=items+itemDescripts.join("^")+String.fromCharCode(2)+itemTypes.join("^")+String.fromCharCode(2);
		items=items+itemCreateT.join("^")+String.fromCharCode(2)+itemExps.join("^")+String.fromCharCode(2)+itemDataTypes.join("^");
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"InsertQryObj",
			wantreturnval:0,
			QryObj:qryObjCode+"^"+qryObjName+"^"+QryObjDesc+"^"+qryObjDSID,
			QryItems:items
		},function(jsonData){
				$.messager.alert("提示",jsonData.msg);
				if (jsonData.success==1) {
					$('#qryObj-addDlg').dialog('close');

					$('#mainShowGrid').datagrid('reload',{
						ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
						MethodName:"GetBDQObj",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
						searchV:"",
						wantreturnval:0
						
					});
					
				}
			
		});		
		
	}	
	

	///加载主界面datagrid
	var mainShowGrid = $HUI.datagrid("#mainShowGrid",{
		url:$URL,
		
		queryParams:{
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"GetBDQObj",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
			wantreturnval:0
		},
		idField:'ID',
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Descript',title:'描述',width:100,align:'left'},
			{field:'DSType',title:'数据源类型',width:100,align:'left'},
			{field:'DSName',title:'数据源名称',width:100,align:'left'},
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
				var rowdataid="\""+row.ID+"\"";		//datagrid的idField；
				var selector='"#mainShowGrid"';
				var s = "<a href='#' title='明细' class='hisui-tooltip' ><span class='icon icon-apply-check'  onclick='showDetail("+rowdataid+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.delQryObj("+rowdataid+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
				return s;
				
				
				} 
			}			
			
	    ]],
		pagination:true,
		pageSize:15,
	    pageList:[5,10,15,20,50,100],
		fit:true,
		fitColumns:true,
		//Select事件响应方法
		onDblClickRow:function(rowIndex,rowData){
			LoadCfgData();
			$('#rptCfgDiv').panel('setTitle','配置查询条件['+curCfgName+']');
			$('#loadCfgDlg').dialog('close');
		}
	});
	
	var dataSrcID="";	//保存数据源ID
	
		///新增响应方法
	$("#qryobj-addBtn").click(function (argument) {
		
		$(function(){
			$("#DataSrc").lookup({
				//readonly:true,
				editable:false,
				width:370,
				panelWidth:400,
				url:$URL,
				queryParams:{
					ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
					MethodName:"GetDS",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
					DSType:"",
					DSName:"",
					wantreturnval:0
				},
				mode:'remote',
				idField:'Code',
				textField:'Name',
				columns:[[  
					{field:'ID',title:'ID',width:120,hidden:true}, 
					{field:'Code',title:'编码',width:120},  
					{field:'Name',title:'名称',width:120},  
					{field:'Descript',title:'描述',width:150},  
					{field:'Type',title:'类型',width:150}  
				]],
				pagination:true,
				onSelect:function(index,rowData){
					if (dataSrcID!=rowData.ID){
						dataSrcID=rowData.ID;
						dataSrcObj=rowData;
					}
					
					//console.log("index="+index+",rowData=",rowData);
					//propertyGrid.load({DSID:dataSrcID})
				}
			});
	    
	    	//$("#DataSrc").width($("#idQryName").width())
	    
	    })

		////////////////////////////////////////////////////////////////////////////////
		///新增对话框
		$HUI.dialog("#qryObj-addDlg",{
			iconCls:'icon-w-add',
			resizable:false,
			modal:true,
			position: ['center','center'],
			autoOpen: false,
			buttons:[{
				id:'btnPrevID',
				text:'上一步',
				handler:OnPrev,
			},{
				id:'btnNextID',
				text:'下一步',
				handler:OnNext
			},{
				text:'取消',
				handler:function(){
					
					//清空datagrid数据
					if ( $("#browseKpiGrid").length > 0 ) {
						$('#browseKpiGrid').datagrid('loadData',{rows:[]});
						$('#kpiGrid').datagrid('loadData',{rows:[]});
						$('#dimGrid').datagrid('loadData',{rows:[]});
					}
					
					//清空名称，编码，描述，数据源
					setFieldValues("ConfigForm",{Code:"",Description:"",Name:"",DS:""});					
					
					$('#qryObj-addDlg').dialog('close');
					OldDataSrcObj=null;
				}			
			}],
			onClose:function(){
				//清空datagrid数据
				if ( $("#browseKpiGrid").length > 0 ) {
					$('#browseKpiGrid').datagrid('loadData',{rows:[]});
					$('#kpiGrid').datagrid('loadData',{rows:[]});
					$('#dimGrid').datagrid('loadData',{rows:[]});
				}
				
				//清空名称，编码，描述，数据源
				setFieldValues("ConfigForm",{Code:"",Description:"",Name:"",DS:""});					
				OldDataSrcObj=null;
			}

		});	
		

		
		$('#qryObj-addDlg').dialog('open');

		editIndex=undefined;
		modifyBeforeRow = {};
		modifyAfterRow = {};
	
		curProgress="start";
		UpdateProgress(curProgress);

		
	});	
	
	
	//////////////////////////////////////////////////////////////
	///增加自定义维度
	$("#qryitem-adddimbtn").click(function (argument) {
		$HUI.dialog("#qryitem-addDimDlg",{
			title:'增加',
			iconCls:'icon-w-add',
			
			resizable:false,
			modal:true,
			position: ['center','center'],
			autoOpen: false,			
			
			
			buttons:[{
				//id:'btnPrevID',
				text:'确定',
				handler:OnAddDimConfirm
			},{
				//id:'btnNextID',
				text:'取消',
				handler:OnAddDimCancel
			}]
			});		
		$('#qryitem-addDimDlg').dialog('open');
	});	


	//////////////////////////////////////////////////////////////
	///增加聚合度量
	$("#qryitem-addAggBtn").click(function (argument) {
		var values={
			Code:"",
			Name:"",
			Descript:"",
			MethodName:"",
			MethodArgs:""
		};
		
		//setFieldValues("addDimForm",values)
		showAddAggDlg.curCfgData=null;
		showAddAggDlg(values);

	});	
	
		
	function OnAddDimConfirm() {
		
	};
	function OnAddDimCancel() {
		
	};

	
	
	
	


	
	
	function OnPrev() {
		if (curProgress=="start" ){
				return;
		}else{
			 if (dataSrcObj.Type=="主题") {
				proObj.theme.OnPrev();
			}else if (dataSrcObj.Type=="指标") {
				proObj.kpi.OnPrev();
			}
		}
	
		UpdateProgress(curProgress);
		
	}
	
	function OnNext() {
		if (curProgress=="start" ) {
			flag = $("#ConfigForm").form("validate");   //表单内容合法性检查
			if (!flag){
				myMsg("请按照提示填写信息");
				return;
			}
			curProgress="second";
		}else{
		
			if (dataSrcObj.Type=="主题") {
				proObj.theme.OnNext();
			}else if (dataSrcObj.Type=="指标") {
				proObj.kpi.OnNext();
			}		
		}

		
		UpdateProgress(curProgress);
		
	}
	
	function UpdateProgress(curProgress){
		if (curProgress=="start" ) {
			$("#ConfigForm").attr("style","display:block;");
			$('#propertyPanel').hide();
			$("#summaryPanel").hide();
			$("#addKpiDiv").attr("style","display:none;");
			
			//$('#qryObj-addDlg').dialog("restore");
			
			$('#btnPrevID').linkbutton("disable");
			$("#btnNextID").html("<span class=\"l-btn-left\"><span class=\"l-btn-text\">下一步</span></span>")		
	
		}else {
			
			if (dataSrcObj.Type=="主题") {
				proObj.theme.UpdateProgress(curProgress);
			}else if (dataSrcObj.Type=="指标") {
				proObj.kpi.UpdateProgress(curProgress)
			}
		}

	}
	
	///////////////////////////////////////////////////////////
	//通用方法
	//设置表单值
	function setFieldValue(formID,fieldName,value) {
		$("form#"+formID+" [name='"+fieldName+"']").val(value);		
	};
	//给form各字段赋值
	function loadRecord(formID,rowData) {
		var x;
		for(x in rowData) {
			setFieldValue(formID,x,rowData[x]);
		}		
	}
	//得到form各字段赋值
	function getFieldValues(formID){
		var values=new Object();
		var selector="form#"+formID+" input";
		$(selector).each(function(){
			if (!$(this).attr("name")) return;
			//alert($(this).attr("name")+":"+$(this).val());
			values[$(this).attr("name")]=$(this).val();
		});
		
		return values;
		
	}
	
	//保存配置
	function SaveConfig() {
		var values=getFieldValues("ConfigForm");
		var qryObjCode=values.Code;
		var qryObjName=values.Name;
		var QryObjDesc=values.Description;
		var qryObjDSID=dataSrcObj.ID;
		
		
		var propertyData=$('#propertygrid').datagrid("getData");
		var len=propertyData.total;
				
		var itemCodes=[],itemNames=[],itemDescripts=[],itemTypes=[],itemCreateT=[],itemExps=[],itemDataTypes=[];
		
		for(var i=0;i<len;i++){
			var rec=propertyData.rows[i];
			itemCodes.push(rec.Code); 
			itemNames.push(rec.Name); 
			itemDescripts.push(rec.Descript); 
			itemTypes.push(rec.Type); 
			itemCreateT.push(rec.CreateType); 
			itemExps.push(rec.Exp); 
			itemDataTypes.push(rec.DataType); 
		};
		var items=itemCodes.join("^")+String.fromCharCode(2)+itemNames.join("^")+String.fromCharCode(2);
		items=items+itemDescripts.join("^")+String.fromCharCode(2)+itemTypes.join("^")+String.fromCharCode(2);
		items=items+itemCreateT.join("^")+String.fromCharCode(2)+itemExps.join("^")+String.fromCharCode(2)+itemDataTypes.join("^");
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"InsertQryObj",
			wantreturnval:0,
			QryObj:qryObjCode+"^"+qryObjName+"^"+QryObjDesc+"^"+qryObjDSID,
			QryItems:items
		},function(jsonData){
				$.messager.alert("提示",jsonData.msg);
				if (jsonData.success==1) {
					$('#qryObj-addDlg').dialog('close');

					$('#mainShowGrid').datagrid('reload',{
						ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
						MethodName:"GetBDQObj",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
						searchV:"",
						wantreturnval:0
						
					});
					
				}
			
		});		
		
	}
};



$(init);

init.delQryObj=function(ID) {
	$.messager.confirm("删除", "确定要删除数据吗?", function (r) { 
	if (r) { 	
		$cm({
				ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
				MethodName:"DelQryObj",
				wantreturnval:0,
				qryObjID:ID
			},function(jsonData){
				if (jsonData.success==1) {
					$('#mainShowGrid').datagrid('reload',{
						ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
						MethodName:"GetBDQObj",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
						searchV:"",
						wantreturnval:0
						
					});				
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
					

			});
	}})
	

}
	/*
function setProgressBar(curProgress) {
	var unfinishedColor = '#B3B3B3';
	var finishedColor = '#40A2DE';
	if (curProgress=="start") {
		$('#start')
		.css('background-color', finishedColor)
		.next('span').css('color', finishedColor)
		.parent('div').prev('div.progress-line').css('background-color', unfinishedColor)

		$('#second')
		.css('background-color', unfinishedColor)
		.next('span').css('color', unfinishedColor)
		.parent('div').prev('div.progress-line').css('background-color', unfinishedColor)

		$('#end')
		.css('background-color', unfinishedColor)
		.next('span').css('color', unfinishedColor)		
		
	}else if (curProgress=="second") {
		$('#start')
		.css('background-color', finishedColor)
		.next('span').css('color', finishedColor)
		.parent('div').prev('div.progress-line').css('background-color', finishedColor)

		$('#second')
		.css('background-color', finishedColor)
		.next('span').css('color', finishedColor)
		.parent('div').prev('div.progress-line').css('background-color', unfinishedColor)

		$('#end')
		.css('background-color', unfinishedColor)
		.next('span').css('color', unfinishedColor)		
	}else if (curProgress=="end") {
		$('#start')
		.css('background-color', finishedColor)
		.next('span').css('color', finishedColor)
		.parent('div').prev('div.progress-line').css('background-color', finishedColor)

		$('#second')
		.css('background-color', finishedColor)
		.next('span').css('color', finishedColor)
		.parent('div').prev('div.progress-line').css('background-color', finishedColor)

		$('#end')
		.css('background-color', finishedColor)
		.next('span').css('color', finishedColor)		
	}
	*/