var init = function(){
	var curRptObj={
		Code:"",
		Name:"",
		ID:"",
		DateItemCode:"",
		DateItemUpdated:true,
		showType:""
	};
	var curQryObj;
	$(function(){
		$("#inputQryObj").lookup({
			width:200,
			panelWidth:400,
			url:$URL,
			queryParams:{
				ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
				MethodName:"GetBDQObj",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
				wantreturnval:0
			},
			mode:'remote',
			idField:'Code',
			textField:'Name',
			columns:[[  	
				{field:'ID',title:'ID',width:100,align:'left',hidden:true},
				{field:'Code',title:'编码',width:100,align:'left'},
				{field:'Name',title:'名称',width:100,align:'left'},
				{field:'Descript',title:'描述',width:100,align:'left'},
				{field:'DSType',title:'数据源类型',width:100,align:'left'},
				{field:'DSName',title:'数据源名称',width:100,align:'left'} 
			]],
			pagination:true,
			onSelect:function(index,rowData){
				if (curQryObj==null || curQryObj.ID!=rowData.ID) 
				{
					refreshTree(rowData);
					
				}	
			}
		
		})
	});
	
	$('#rptFormLookup').form({
		onSubmit: function(){
			return false;
		}
	});
    




 	var DataItem=$HUI.combobox('#DataItem',{
			valueField:'value',     
			textField:'text',    
			method:'get',               
			url:'',          
			required:true ,
			editable:false,
			onBeforeLoad: function(param){
				if (curRptObj.DateItemUpdated==false) {
					$('#DataItem').combobox("setValue",curRptObj.DateItemCode);
					curRptObj.DateItemUpdated=true;
					
				}
			}
 

	 	});
 	
 	
 	
 	
		//树节点，向下查找
		//order=1,正向查找；order=-1,反向查找
	function findNode(curNode,aryNodes,searchUnit,searchV,order) {
		var len=aryNodes.length;
		var firsthalf=[];
		var latterhalf=[];
		var curPos=len;
		for(var i=0;i<len;i++){
			var node=aryNodes[i];
			if (node==curNode) {
				curPos=i;
				continue;
			}else if (node[searchUnit].toLowerCase().indexOf(searchV.toLowerCase())>=0) {
				if (i<curPos) firsthalf.push(node);
				else latterhalf.push(node);
			}
		}
		
		var latterhalf=latterhalf.concat(firsthalf);
		if (latterhalf.length==0) return null;
		if (order==1) return latterhalf[0];
		else if (order==-1) return latterhalf[latterhalf.length-1];
		
	}	
		
	$(function(){
		$('#searchObjNext').bind('click', function(){
			var values=getFieldValues("rptFormLookup");
			var searchV=values.inputSearchNode;

			var nodes =$('#qryObjTree').tree('getChildren');
			var curSel=$('#qryObjTree').tree('getSelected');
			
			
			var node=findNode(curSel,nodes,"text",searchV,1)
			if (node!=null) $('#qryObjTree').tree('select', node.target).tree('expandTo', node.target).tree('scrollTo', node.target)     ;
		});
	});
	
	$(function(){
		$('#searchObjPrev').bind('click', function(){
			var values=getFieldValues("rptFormLookup");
			var searchV=values.inputSearchNode;

			var nodes =$('#qryObjTree').tree('getChildren');
			var curSel=$('#qryObjTree').tree('getSelected');
			
			
			var node=findNode(curSel,nodes,"text",searchV,-1)
			if (node!=null) $('#qryObjTree').tree('select', node.target).tree('expandTo', node.target).tree('scrollTo', node.target)     ;
		});
	});	
	
	
	$('#qryObjTree').tree({
		lines:true,
		onDblClick:function(node){
			if(node.id=="dimChild" || node.id=="measureChild") {
				return;
			};
			
			var tabgridMap={
				"rptcolDiv":"#rptcolGrid",		//列配置
				"rptrowDiv":"#rptrowGrid",		//行配置
				"rptcrossDiv":"#rptcrossGrid",		//交叉汇总
				"rptfilterDiv":"#rptfilterGrid",			//过滤
				"rptorderDiv":"#rptorderGrid",			//排序
				"rptquerycondDiv":"#rptquerycondGrid"		//报表参数
				
			};
			
			
			var tab = $('#rptcfgTab').tabs('getSelected');
			var curPanelID=tab[0].id;

			if(tabgridMap[curPanelID]=="#rptorderGrid"){
				$.messager.alert("提示","新增排序时，点击排序页面上的‘新增’按钮。");
				return;				
			}

			if(tabgridMap[curPanelID]=="#rptfilterGrid"){
				var pNode=$('#qryObjTree').tree('getParent',node.target);		
				if (pNode.id=="measureChild") {					
					$.messager.alert("提示","度量不能作为过滤项！");
					return;	
				}			
			}			
			
			//var index = $('#rptcfgTab').tabs('getTabIndex',tab);
			if (tabgridMap[curPanelID]=="#rptfilterGrid") {
				node.id=rptfilterGrid.tempID;
				rptfilterGrid.tempID=rptfilterGrid.tempID+1;
			}
			addNode2Row(tabgridMap[curPanelID],node);

			
			if (tabgridMap[curPanelID]=="#rptcolGrid" || tabgridMap[curPanelID]=="#rptrowGrid" || tabgridMap[curPanelID]=="#rptcrossGrid") {
				$(tabgridMap[curPanelID]).datagrid('enableDnd');
			}
			
			
			
			/*
			var tabgridMap={
				0:"#rptcolGrid",		//列配置
				1:"#rptrowGrid",		//行配置
				2:"#rptcrossGrid",		//交叉汇总
				3:"#rptfilterGrid",			//过滤
				4:"#rptorderGrid",			//排序
				5:"#rptquerycondGrid"		//报表参数
				
			};
			var tab = $('#rptcfgTab').tabs('getSelected');
			var index = $('#rptcfgTab').tabs('getTabIndex',tab);
			if (index==3) {
				node.id=rptfilterGrid.tempID;
				rptfilterGrid.tempID=rptfilterGrid.tempID+1;
			}
			addNode2Row(tabgridMap[index],node);

			$("#rptcolGrid").datagrid('enableDnd');
			$("#rptorderGrid").datagrid('enableDnd');
			//if (index==2) {
				$("#rptrowGrid").datagrid('enableDnd');
				$("#rptcrossGrid").datagrid('enableDnd');
			//}
			*/
		}
					
	});

	function addNode2Row(selStr,node){	
		var pNode=$('#qryObjTree').tree('getParent',node.target);
		var ID=node.id;
		var Code=node.attributes.code;
		var Name=node.text;
		
		if (pNode.id!="dimChild" && pNode.id!="measureChild") {
			//说明此节点是属性节点
			Code=pNode.attributes.code+"->"+Code;
			Name=pNode.text+"->"+Name;
		}
		
		
		var opts = $(selStr).datagrid('getColumnFields');
		var addData={};
		for(var i=0;i<opts.length;i++) {
			if (opts[i]=="action") continue;
			addData[opts[i]]="";
		}
		$.extend(addData,{
			ID: node.id,
			Code: Code,
			Name: Name
		});
		
		if (selStr=="#rptcolGrid" && showType=="网格报表" && pNode.id=="measureChild") {
			addData.QryItemType="度量";
			addData.Format="#0.00";
		}
		
		if (selStr=="#rptcrossGrid" && showType=="交叉报表") {
			addData.Format="#0.00";
		}		
		//#rptcolGrid
		
		$(selStr).datagrid('appendRow',addData);	
	}

	///////////////////////////////////////////////////////////////////////////////
	///报表列
	var rptcolGrid = $HUI.datagrid("#rptcolGrid",{
		idField:'Code',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'QryItemType',title:'QryItemType',width:100,align:'left',hidden:true},
			{field:'GrpParam',title:'组/子组参数',width:100,align:'left'},//add by wz.2020-05-12
			{field:'Format',title:'显示格式',width:50,align:'left',hidden:true,
				editor:{                            
					type:'combobox',                  
					options:{            
						valueField: 'value',     
						textField: 'label',      
						data: [{                      
								label: '#0.0',         
								value: '#0.0'          
							},{                 
								label: '#0.00',         
								value: '#0.00'          
							},{                      
								label: '#0.000',         
								value: '#0.000'          
							},{                 
								label: '#',         
								value: '#'          
							}
						] 
					}
				}
			
			},
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
				var rowdataid="\""+row.Code+"\"";		//datagrid的idField；
				var selector='"#rptcolGrid"';
				var s ="" ;
				var editOpera="";				
				if (showType=="网格报表") {
					if (row.QryItemType=="度量") {
						editOpera = "<a href='#' title='修改/结束修改' class='hisui-tooltip' ><span class='icon icon-write-order'  onclick='init.editRptItem("+selector+','+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;";
					}
					s =editOpera+"<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";					
				
				}else if (showType=="交叉报表") {
					s = "<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
				}
				return s;
				} 
			}
	    ]],
		fit:true,
		fitColumns:true,
		onAfterEdit:function(rowIndex,rowData,changes){
			$("td.datagrid-value-changed").removeClass("datagrid-value-changed");
		},
		onRowContextMenu :  function(e,rowIndex,rowData){
			if (showType=="网格报表") return;
			var isGrp=isGrpOrSubGrp(rowData.Code);
			if (isGrp==0) return;
			e.preventDefault();//阻止向上冒泡
			$(this).datagrid('unselectAll');
			$(this).datagrid('selectRow',rowIndex);
			$('#menuCfgColGrp').menu('show',{
				left : e.pageX,
				top : e.pageY
			});
		}		
		
	});
	function isGrpOrSubGrp(code){
		var flag=0;
		var aryGrp=["ItemGrp","ItemBsGrpOrder","IsBSGrpMember","ItemBsGrpDesc","ItemSubGrp","ItemSubGrpDesc","ItemSubGrpCode","ItemSubGrpOrder"];
		for(var x in aryGrp){
			if(code.indexOf(aryGrp[x])>=0){
				flag=1;
				break;
			}
		}
		return flag;
	}
	
	$("#btnCfgColGrp").click(function (argument) {
		setGrpParam("rptcolGrid");		
	});
	
	$("#btnCfgRowGrp").click(function (argument) {
		setGrpParam("rptrowGrid");		
	});	
	$("#btnCfgFilterGrp").click(function (argument) {
		setGrpParam("rptfilterGrid");		
	});
	
	$("#btnCleanColGrp").click(function (argument) {
		cleanGrpParam("rptcolGrid");		
	});	
	
	$("#btnCleanRowGrp").click(function (argument) {
		cleanGrpParam("rptrowGrid");		
	});

	$("#btnCleanFilterGrp").click(function (argument) {
		cleanGrpParam("rptfilterGrid");		
	});	
	
	function cleanGrpParam(selector){

		var rowData=$("#"+selector).datagrid('getSelected');
		var rowInx=$("#"+selector).datagrid('getRowIndex',rowData);
		rowData.GrpParam="";
		$("#"+selector).datagrid('updateRow', {
			index:rowInx,
			row: rowData
		});
		
		
	}		
	
	function setGrpParam(selector){
		$.messager.prompt("提示", "请输入参数值：", function (r) {
			if (r) {
				var rowData=$("#"+selector).datagrid('getSelected');
				var rowInx=$("#"+selector).datagrid('getRowIndex',rowData);
				rowData.GrpParam=r;
				$("#"+selector).datagrid('updateRow', {
					index:rowInx,
					row: rowData
				});
			} 
		});			
		
	}
	
	
	///////////////////////////////////////////////////////////////////////////////
	///报表行
	var rptrowGrid = $HUI.datagrid("#rptrowGrid",{
		idField:'Code',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Name',title:'名称',width:100,align:'left'},
			//{field:'Descript',title:'描述',width:100,align:'left'},
			{field:'GrpParam',title:'组/子组参数',width:100,align:'left'},//add by wz.2020-05-12
			{field:'action',title:'删除',width:70,align:'left',
				formatter:function(value,row,index){
				var rowdataid="\""+row.Code+"\"";		//datagrid的idField；
				var selector='"#rptrowGrid"';
				var s = "<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
				return s;
				} 
			}
	    ]],
		fit:true,
		fitColumns:true,
		onRowContextMenu :  function(e,rowIndex,rowData){
			if (showType=="网格报表") return;
			var isGrp=isGrpOrSubGrp(rowData.Code);
			if (isGrp==0) return;
			e.preventDefault();//阻止向上冒泡
			$(this).datagrid('unselectAll');
			$(this).datagrid('selectRow',rowIndex);
			$('#menuCfgRowGrp').menu('show',{
				left : e.pageX,
				top : e.pageY
			});
		}
	});
	
	///交叉汇总
	var rptcrossGrid = $HUI.datagrid("#rptcrossGrid",{
		idField:'Code',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:100,align:'left'},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Format',title:'显示格式',width:50,align:'left',
				editor:{                            
					type:'combobox',                  
					options:{            
						valueField: 'value',     
						textField: 'label',      
						data: [{                      
								label: '#0.0',         
								value: '#0.0'          
							},{                 
								label: '#0.00',         
								value: '#0.00'          
							},{                      
								label: '#0.000',         
								value: '#0.000'          
							},{                 
								label: '#',         
								value: '#'          
							}
						] 
					}
				}
			
			},
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
					var rowdataid="\""+row.Code+"\"";		//datagrid的idField；
					var selector='"#rptcrossGrid"';
					//var s = "<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-remove'  onclick='init.removeRptItem("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
					var s = "<a href='#' title='修改/结束修改' class='hisui-tooltip' ><span class='icon icon-write-order'  onclick='init.editRptItem("+selector+','+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
					return s;
				} 
			}
	    ]],
		fit:true,
		fitColumns:true,
		onAfterEdit:function(rowIndex,rowData,changes){
			$("td.datagrid-value-changed").removeClass("datagrid-value-changed");
		}
	});	///////////////////////////////////////////////////////////////////////////////
	///过滤
	var rptfilterGrid = $HUI.datagrid("#rptfilterGrid",{
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:100,align:'left',hidden:true},
			{field:'logical',title:'逻辑符',width:100,align:'left',
				editor:{                            
					type:'combobox',                  
					options:{            
						valueField: 'value',     
						textField: 'label',      
						data: [{                 
								label: ' ',         
								value: ' '          
							},{                 
								label: 'AND',         
								value: 'AND'          
							},{                      
								label: 'OR',         
								value: 'OR'          
							},{                      
								label: 'AND (',         
								value: 'AND ('          
							},{                 
								label: 'OR (',         
								value: 'OR ('          
							},{                      
								label: '(',         
								value: '('          
							},{                      
								label: ')',         
								value: ')'          
							}
						] 
					}
				}
			
			},
			
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Relational',title:'关系符',width:100,align:'left',
				editor:{                            
					type:'combobox',                  
					options:{            
						valueField: 'label',     
						textField: 'value',      
						data: [{                 
								label: '=',         
								value: '=',          
							},{                      
								label: '>',         
								value: '>',          
							},{                      
								label: '<',         
								value: '<',          
							},{                 
								label: '>=',         
								value: '>=',          
							},{                      
								label: '<=',         
								value: '<=',          
							},{                      
								label: '<>',         
								value: '<>',          
							},{                      
								label: 'like',         
								value: 'like',          
							},{                 
								label: 'in',         
								value: 'in',          
							},{                      
								label: 'between',         
								value: 'between' ,         
							},{                      
								label: 'is null',         
								value: 'is null',          
							},{                      
								label: 'is not null',         
								value: 'is not null'          
							}
						] 
					}
				}			
			
			},
			{field:'V1',title:'值1',width:100,align:'left',editor:'text'},
			{field:'V2',title:'值2',width:100,align:'left',editor:'text'},
			{field:'action',title:'操作',width:100,align:'left',
				formatter:function(value,row,index){
				var rowdataid=row.ID;
				var selector='"#rptfilterGrid"';
				var s = "<a href='#' title='修改/结束修改' class='hisui-tooltip' ><span class='icon icon-write-order'  onclick='init.editRptItem("+selector+','+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",init.refreshFilterStr)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
				return s;
				} 
			},
			{field:'GrpParam',title:'组/子组参数',width:100,align:'left'},//add by wz.2020-05-12
	    ]],
		fit:true,
		fitColumns:true,
		onClickRow:	function(inx){
						//结束编辑
			var ID=$(this).datagrid('getRows')[inx].ID;
			if (init.editID != undefined && init.editID != ID){
				init.endEditing(this,ID);
			}
		},
		onAfterEdit:function(rowIndex,rowData,changes){
			init.refreshFilterStr();
			$("td.datagrid-value-changed").removeClass("datagrid-value-changed");
		},
		onRowContextMenu :  function(e,rowIndex,rowData){
			var isGrp=isGrpOrSubGrp(rowData.Code);
			if (isGrp==0) return;
			e.preventDefault();//阻止向上冒泡
			$(this).datagrid('unselectAll');
			$(this).datagrid('selectRow',rowIndex);
			$('#menuCfgFilterGrp').menu('show',{
				left : e.pageX,
				top : e.pageY
			});
		}		
	});
	$("#filter-addBtn").click(function (argument) {
		id=rptfilterGrid.tempID;
		rptfilterGrid.tempID=rptfilterGrid.tempID+1;
		
		$("#rptfilterGrid").datagrid('appendRow',{
			ID: id,
			Code:"",
			logical:"",
			Name:"",
			Relational:"",
			V1:"",
			V2:""
		});		
		
		
	});
	
	
	rptfilterGrid.tempID=0;


	///////////////////////////////////////////////////////////////////////////////
	///排序
	var rptorderGrid = $HUI.datagrid("#rptorderGrid",{
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:100,align:'left',hidden:true},
			{field:'Name',title:'名称',width:100,align:'left'},
			{field:'Type',title:'排序方式',width:100,align:'left',
				editor:{                            
					type:'combobox',                  
					options:{            
						valueField: 'value',     
						textField: 'label',      
						data: [{                 
								label: '升序',         
								value: '升序'          
							},{                 
								label: '降序',         
								value: '降序'          
							}
						] 
					}
				}			
			},
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
				var rowdataid=row.ID;
				var selector='"#rptorderGrid"';
				var s = "<a href='#' title='修改/结束修改' class='hisui-tooltip' ><span class='icon icon-write-order'  onclick='init.editRptItem("+selector+','+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>&nbsp;&nbsp;<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
				return s;
				} 
			}
	    ]],
		fit:true,
		fitColumns:true,
		onClickRow:	function(inx){
			//结束编辑
			var ID=$(this).datagrid('getRows')[inx].ID;
			if (init.editID != undefined && init.editID != ID){
				init.endEditing(this,ID);
			}
		},
		onAfterEdit:function(rowIndex, rowData, changes) {
			$("td.datagrid-value-changed").removeClass("datagrid-value-changed");
		}		
	});


	///////////////////////////////////////////////////////////////////////////////
	///查询条件
	var rptquerycondGrid = $HUI.datagrid("#rptquerycondGrid",{
		idField:'ID',	//必须要设置这个属性！在调用getRowIndex时会用到
		columns:[[
			{field:'ID',title:'ID',width:100,align:'left',hidden:true},
			{field:'Code',title:'编码',width:100,align:'left',hidden:true},
			{field:'Name',title:'名称',width:100,align:'left'},
			/*{field:'Default',title:'默认值',width:100,align:'left'},*/
			{field:'action',title:'操作',width:70,align:'left',
				formatter:function(value,row,index){
				var selector='"#rptorderGrid"';
				
				var rowdataid=row.ID;		//datagrid的idField；
				var selector='"#rptquerycondGrid"';
				var s = "<a href='#' title='删除' class='hisui-tooltip' ><span class='icon icon-cancel'  onclick='init.removeRptItem("+selector+","+rowdataid+",null)'>&nbsp;&nbsp;&nbsp;&nbsp;</span></a>";
				return s;
				} 
			}
	    ]],
		fit:true,
		fitColumns:true
	});
	
	
	////////////////////////////////////////////////////////////////////////////
	////保存
	
	function validateSavedData(saveType,funCallback){
		if ($("#rptcolGrid").datagrid("getData").total<=0) {
			$.messager.alert("提示","没有配置报表列，请配置报表列后再保存！");
			$('#rptcfgTab').tabs('select',"报表列");
			return;
		}		
		
		var qryObjText=$("#inputQryObj").lookup("getText");
		//flag = $("#rptFormQryObj").form("validate");   //表单内容合法性检查
		if (qryObjText==""){
			$.messager.alert("提示","请选择查询对象后再保存！");
			return;
		}			
		
		
		
		if (curQryObj.DSType=="主题") {
			/*
			flag = $("#rptFormQryObj").form("validate");   //表单内容合法性检查
			if (!flag){
				$.messager.alert("提示","请按照提示填写信息");
				return;
			}
			*/
			var dataItemV=$('#DataItem').combobox("getValue")
			if (dataItemV==""){
				$.messager.alert("提示","请选择日期项后再保存！");
				return;
			}
			
			//检查排序的字段是否属于列字段
			//交叉报表没有排序
			if ($("#rptorderGrid").length>0) {
				var rptcolDatas=$("#rptcolGrid").datagrid("getData");
				var rptorderDatas=$("#rptorderGrid").datagrid("getData");

				for(var i=0;i<rptorderDatas.rows.length;i++) {
					var isSame=0;
					for(var j=0;j<rptcolDatas.rows.length;j++) {
						if (rptcolDatas.rows[j].Code==rptorderDatas.rows[i].Code) {
							isSame=1;
							break;	
						}
					}
					if (isSame==0) {
						$.messager.alert("提示","排序的字段必须是报表列字段！请重新配置报表列或排序。");
						return;					
					}
									
				}
			}
						
			
		};	
		

		
			
		
		if(saveType=="save") {
			if (curRptObj.Code=="" || curRptObj.Code=="tempSysRpt"){
				saveType="saveAs"
			}else{
				saveRpt(saveType,null,null);
			}
			//如果当前保存在数据库中不存在就执行另存逻辑,
			//saveType="saveAs"
		}
		if (saveType=="saveAs") {
			$HUI.dialog("#rptcfg-saveDlg",{
				title:'保存',
				iconCls:'icon-w-paper',
				
				resizable:false,
				modal:true,
				position: ['center','center'],
				autoOpen: false,			
				
				
				buttons:[{
					//id:'btnPrevID',
					text:'确定',
					handler:OnSaveConfirm
				},{
					//id:'btnNextID',
					text:'取消',
					handler:OnSaveCancel
				}]
				});		
			$('#rptcfg-saveDlg').dialog('open');			

			//弹出对话框，录入编码，名称，描述，业务类型
		} 
	}
	function OnSaveCancel() {
		$('#rptcfg-saveDlg').dialog('close');
	}
	function OnSaveConfirm() {
		flag = $("#saveForm").form("validate");   //表单内容合法性检查
		if (!flag){
			$.messager.alert("提示","请按照提示填写信息");
			return;
		}		
		var values=getFieldValues("saveForm");
		var code=values.Code;
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"GetRptIdByCode",
			rptCode:code
		},function(jsonData){
				if (jsonData.success==1) {
					if (jsonData.ID!="") {
						$.messager.alert("提示","该编码已被使用！请修改编码后再试。");
					}else{
						
						saveRpt("saveAs",null,values);
						$('#rptcfg-saveDlg').dialog('close');
					}
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
		});	



		
		
	}
	
	
	function saveRpt(saveType,funCallback,savedRptInfo) {
		var allItems=[];
		var allItemsStr=[];
		
		var gridSels=[];
		gridSels.push("#rptcolGrid");
		gridSels.push("#rptfilterGrid");
		gridSels.push("#rptorderGrid");
		gridSels.push("#rptquerycondGrid");
		
		gridSels.push("#rptrowGrid");
		gridSels.push("#rptcrossGrid");
		var colDataStr="";
		for(var j=0;j<gridSels.length;j++){
			if ($(gridSels[j]).length>0) { 
				var items=$(gridSels[j]).datagrid("getData").rows;
				colDataStr="";
				var curProRows=	items;
				for(var i=0;i<curProRows.length;i++){
					$(gridSels[j]).datagrid("endEdit",i);
					var rowDataStr="";
					var rowData=curProRows[i];
					for(x in rowData){
						var v=rowData[x];
						if (rowDataStr!="") rowDataStr=rowDataStr+"^";
						rowDataStr=rowDataStr+x+":"+v; 
					};
					if (colDataStr!="") colDataStr=colDataStr+String.fromCharCode(2);
					colDataStr=colDataStr+rowDataStr;
				}
			}else{
				colDataStr="";
				
			}
			allItemsStr[j]=colDataStr;
		}
		init["#rptcolGrid"]={editID:undefined};
		init["#rptfilterGrid"]={editID:undefined};
		init["#rptorderGrid"]={editID:undefined};
		init["#rptcrossGrid"]={editID:undefined};
		var code,name,descript,businessType,dateItemCode
		var showType=curRptObj.showType;
		//var values=getFieldValues("#rptFormQryObj");
		//var dateItemCode=values.DataItem;
		var dateItemCode=$('#DataItem').combobox("getValue")	
		var creator=session['LOGON.USERID'];
		var	qryObjID=curQryObj.ID;

		if(saveType=="save") {
			code=curRptObj.Code;

		}else if (saveType=="saveAs") {
			code=savedRptInfo.Code;
			/// 名称
			name=savedRptInfo.Name;
			/// 描述
			descript=savedRptInfo.Descript;
			/// 业务类型，包括：收入，挂号，手术等等
			businessType=savedRptInfo.BusinessType;	
		}; 					
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"InsertRpt",
			wantreturnval:0,
			colStr:allItemsStr[0],
			filterStr:allItemsStr[1],
			orderStr:allItemsStr[2],
			querycondStr:allItemsStr[3],
			rowStr:allItemsStr[4],
			crossStr:allItemsStr[5],			
			saveType:saveType,
			/// 编码
			code:code,
			/// 名称
			name:name,
			/// 描述
			descript:descript,
			/// 查询对象ID
			qryObjID:qryObjID,
			/// 显示类型，包括：行式报表和交叉报表
			showType:showType,
			/// 创建者
			creator:creator,
			/// 业务类型，包括：收入，挂号，手术等等
			businessType:businessType,
			/// 统计的日期口径
			dateItemCode:dateItemCode
		},function(jsonData){
				if (jsonData.success==1) {
					if (saveType=="saveAs") {
						curRptObj.Code=jsonData.rptCode;
						curRptObj.Name=jsonData.rptName;
						curRptObj.ID=jsonData.rptId;
					}
					//$('#itemcfg').panel('setTitle',"当前配置报表："+curRptObj.Name);
					
					$('#actLabel').html("修改 - "+curRptObj.Name);	
					
					if (funCallback!=null) {
						funCallback(jsonData);	
					}else{
						showMsgByPop('保存成功！','success');
						//$.messager.popover({msg: '保存成功！',type:'success',timeout:3000});
						//$.messager.alert("提示",jsonData.msg);
					}
					
					window.parent.$HUI.datagrid("#browseGrid","reload");
					
					
				}else{
					$.messager.alert("提示",jsonData.msg);
				}
		});				
	};
	
	var onCheckFilter=function(){

			var items=$("#rptfilterGrid").datagrid("getData").rows;
			var colDataStr="";
			var curProRows=	items;
			if (curProRows.length==0) {
					$.messager.alert("提示","未配置过滤！");
					return;
			}
			for(var i=0;i<curProRows.length;i++){
				$("#rptfilterGrid").datagrid("endEdit",i);
				var rowDataStr="";
				var rowData=curProRows[i];
				for(x in rowData){
					var v=rowData[x];
					if (rowDataStr!="") rowDataStr=rowDataStr+"^";
					rowDataStr=rowDataStr+x+":"+v; 
				};
				if (colDataStr!="") colDataStr=colDataStr+String.fromCharCode(2);
				colDataStr=colDataStr+rowDataStr;
			}
			
			$cm({
				ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
				MethodName:"CheckFilterStr",
				wantreturnval:0,
				filterStr:colDataStr,
				qryObjID:curQryObj.ID
			},function(jsonData){
					if (jsonData.success==1) {
						$.messager.alert("提示","语法正确！");
					}else{
						$.messager.alert("提示",jsonData.msg);
					}
			});			
				
		}
	
	$(function(){
		$('#btnClean').bind('click', function(){
			$.messager.confirm("清除", "未保存的数据将被清除，是否继续?", function (r) {
				if (r) {
					//$.messager.popover({msg:"点击了确定",type:'info'});
					//报表对象
					curRptObj={
						Code:"",
						Name:"",
						ID:"",
						DateItemCode:""
					};
					//查询对象
					$("#inputQryObj").val("");
					//树，统计口径					
					refreshTree({ID:""});
					$('#DataItem').combobox("setValue","");
					
					
					$('#itemcfg').panel('setTitle',"当前配置报表：");
					$("#rptcolGrid").datagrid("loadData",[]);
					$("#rptfilterGrid").datagrid("loadData",[]);
					$("#rptorderGrid").datagrid("loadData",[]);
					$("#rptquerycondGrid").datagrid("loadData",[]);						
				} else {
					//$.messager.popover({msg:"点击了取消"});
				}
			});

		});
		$('#btnSaveCfg').bind('click', function(){
			validateSavedData("save",null);
		});
		//过滤校验
		$('#filter-checkBtn').bind('click',onCheckFilter );
		
		//新增排序
		$('#order-addBtn').bind('click', function(){
			
			//////////////////////////////////////////////////////////////////////////
			/////////排序
			////新增排序对话框
			var addOrderObj = $HUI.dialog("#rptcfg-addOrderDlg",{
				iconCls:'icon-w-add',
				resizable:false,
				modal:true,
				position: ['center','center'],
				autoOpen: false
				,buttons:[{
					text:'确定',
					handler:function(){
						var chkRows=$("#rptcfg-addOrderGrid").datagrid("getSelections");
						for(x in chkRows) {
							var addData={
								ID: chkRows[x].ID,
								Code: chkRows[x].Code,
								Name: chkRows[x].Name,
								Type:"升序"
							};
							$("#rptorderGrid").datagrid('appendRow',addData);
						}
						$('#rptcfg-addOrderDlg').dialog('close');
						$("#rptorderGrid").datagrid('enableDnd');
					}
				},{
					text:'取消',
					handler:function(){
						$('#rptcfg-addOrderDlg').dialog('close');	
					}
				}]
				
			});	
			$('#rptcfg-addOrderDlg').dialog('open');			
				
			///导出datagrid
			//delete addOrderGrid;
			var addOrderGrid = $HUI.datagrid("#rptcfg-addOrderGrid",{
				columns:[[
					{field:'ck',checkbox:'true'},
					{field:'ID',title:'ID',width:100,align:'left',hidden:true},
					{field:'Code',title:'编码',width:100,align:'left',hidden:true},
					{field:'Name',title:'名称',width:100,align:'left'}
			    ]],
				fit:true,
				fitColumns:true
			});				
			//{ total: 0, rows: [] }
			var len=$("#rptcfg-addOrderGrid").datagrid("getData").rows.length;
			for(var i=len-1;i>=0;i--) {
				$("#rptcfg-addOrderGrid").datagrid("deleteRow",i);
			}
				//$('#rptcfg-addOrderGrid').datagrid('loadData',[]);
			
			var rptcolDatas=$("#rptcolGrid").datagrid("getData");
			var rptorderDatas=$("#rptorderGrid").datagrid("getData");
			if (rptcolDatas.rows.length>0) {
				var addDatas=[];
				for(var i=0;i<rptcolDatas.rows.length;i++) {
					var isSame=0;
					for(var j=0;j<rptorderDatas.rows.length;j++) {
						if (rptcolDatas.rows[i].Code==rptorderDatas.rows[j].Code) {
							isSame=1;
							break;	
						}
					}
					if (isSame==0) {
						addDatas.push(rptcolDatas.rows[i]);
					}
									
				}
				
				
				for(x in addDatas) {
					var addData={
						ID: addDatas[x].ID,
						Code: addDatas[x].Code,
						Name: addDatas[x].Name
					};
					$("#rptcfg-addOrderGrid").datagrid('appendRow',addData);

				}
				
			}
		
		});
		
		/*		
		$('#btnPreview').bind('click', function(){
			function showPreview(curRptObj){
				var rptTool="";
				if (curQryObj.DSType=="主题") {
					rptTool="BaseDataQuery";
				}else if (curQryObj.DSType=="指标") {
					rptTool="KpiDataQuery";
				}
				//var windowHeight=window.parent.parent.innerHeight;
				//取到父窗口的原始：window.parent.$HUI
				var tabs=window.parent.parent.$HUI.tabs("#maintabs");
				var TAB_CONTTEMP=[
				    '<iframe id="',
				    , 
				    '"name="',
				    , 
				    '" frameborder="0" marginheight="0px" marginwidth="0px" scrolling="auto" seamless="seamless"  src="',
				    , 
				    '" height="',
				    , 
				    'px" width="',
				    , 
				    '"></iframe>'
				  ];
				TAB_CONTTEMP[7]=window.parent.innerHeight;
				TAB_CONTTEMP[9]="100%";		
				
				var previewURL="dhcwl/v1/bkcdataquery/bkcdataqryview.csp?rpttool="+rptTool+"&rptid="+curRptObj.ID;

				var openTab=tabs.getTab(curRptObj.Name);
				
				
				TAB_CONTTEMP[1]=curRptObj.ID;
				TAB_CONTTEMP[3]=curRptObj.ID;
				TAB_CONTTEMP[5]="/dthealth/web/csp/dhcwlredirect.csp?url="+previewURL;
				var tabcontent=TAB_CONTTEMP.join('');

				tabOptions={
							"id":curRptObj.ID,
							"selected":true,
							"closable":true,
							"cache":false,
							"width":"auto",
							"title":curRptObj.Name,
							"content":tabcontent
						};
						
				if(tabs.exists(curRptObj.Name)){
					tabs.update({
						tab:tabs.getTab(curRptObj.Name),
						options: tabOptions
					});
					tabs.select(curRptObj.Name);
					return true;
				}else{
					tabs.add(tabOptions);
				}				
				
			}			
		
			if (curRptObj.Code=="tempSysRpt" || curRptObj.Code=="") {
				if (!curRptObj.ID) {
					$.messager.alert("提示","请先保存或另存配置后再预览数据！");
				}				
			}else{
				showPreview(curRptObj);
			}
				
		});	
		*/
		
			
		$('#btnSaveAs').bind('click', function(){
			validateSavedData("saveAs",null);
		});			
		
		/*
		$('#btnLoadCfg').bind('click', function(){
			///加载
			var loadGrid = $HUI.datagrid("#rptcfg-loadGrid",{
				url:$URL,
				queryParams:{
					ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
					MethodName:"GetRptCfg",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
					wantreturnval:0,
					creator:session['LOGON.USERID'],
					searchV:""
				},
				columns:[[
					{field:'ID',title:'ID',width:100,align:'left',hidden:true},
					{field:'Code',title:'编码',width:100,align:'left'},
					{field:'Name',title:'名称',width:100,align:'left'},
					{field:'Descript',title:'描述',width:100,align:'left'},
					//{field:'ShowType',title:'类型',width:100,align:'left'},
					{field:'BusinessType',title:'业务类型',width:100},
					{field:'DateItem',title:'日期口径',width:100}
					
			    ]],
				fit:true,
				fitColumns:true,
				pagination:true
			});	
			
			$HUI.dialog("#rptcfg-loadDlg",{
				title:'加载',
				iconCls:'icon-w-add',
				
				resizable:false,
				modal:true,
				position: ['center','center'],
				autoOpen: false,			
				
				
				buttons:[{
					text:'确定',
					handler:OnLoadConfirm
				},{
					text:'取消',
					handler:OnLoadCancel
				}]
				});	
				
			$('#rptcfg-loadDlg').dialog('open');
			
				

			
			function OnLoadCancel() {
				$('#rptcfg-loadDlg').dialog('close');
			}				
			
			///加载界面查询响应方法
			$('#searchRpt').searchbox({
				searcher:function(value){
					loadGrid.load({
						ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
						MethodName:"GetRptCfg",		//通过方法得到grid数据，不带返回值，数据直接在方法中输出	
						wantreturnval:0,
						creator:session['LOGON.USERID'],
						searchV:value
					})
	
				}
			});	
			
		});	
		*/
		
	});
	
	function refreshTree(rowData){

		//清空grid数据		
		$('#itemcfg').panel('setTitle',"当前配置报表：");
		$("#rptcolGrid").datagrid("loadData",[]);
		$("#rptfilterGrid").datagrid("loadData",[]);
		$("#rptorderGrid").datagrid("loadData",[]);
		$("#rptquerycondGrid").datagrid("loadData",[]);						
		$("#rptrowGrid").datagrid("loadData",[]);		
		$("#rptcrossGrid").datagrid("loadData",[]);		
		
		curQryObj=rowData;
		$('#rptcfgTab').tabs('select', '报表列');
		var tabPanel=$('#rptcfgTab').tabs('getTab', '排序');
		if (!!tabPanel) {
			$('#rptcfgTab').tabs('enableTab', '排序');
		}		

		if (curQryObj.DSType=="指标") {
			$(".dataDim").attr("style","visibility:hidden");
			var tabPanel=$('#rptcfgTab').tabs('getTab', '排序');
			if (!!tabPanel) {
				$('#rptcfgTab').tabs('disableTab', '排序');
			}
			
			$('#filter-checkBtn').linkbutton("disable");
			//$('#filter-checkBtn').bind('click',null );
			$("#filter-checkBtn").unbind();

			
		}else if (curQryObj.DSType=="主题") {
			//$(".dataDim").attr("style","display:table-cell;");
			$(".dataDim").attr("style","visibility:visible");
			$('#filter-checkBtn').linkbutton("enable");
			$("#filter-checkBtn").unbind();

			$('#filter-checkBtn').bind('click',onCheckFilter );			
		};

		//if (!!rowData.ID) {
			$cm({
				ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
				MethodName:"GetTreeChildren",
				QryObjID:rowData.ID
			},function(jsonData){
				$('#qryObjTree').tree("loadData",jsonData);
				
			});
		//}
		
		var dataItemUrl=$URL+"?ClassName=web.DHCWL.V1.BKCDQry.BaseDataServ&MethodName=GetItemByDataType&dataType=Date&qryObjID="+rowData.ID;
		$('#DataItem').combobox('reload',dataItemUrl); 
	
	}
	
	
	

	///////////////////////////////////////////////////////////////////////////////
	///工具代码
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
	
	
	function str2Obj(strExp){
		var aryExp=strExp.split("^");
		var expObj={};
		for(var j=0;j<aryExp.length;j++) {
			var k=aryExp[j].split(":")[0];
			var v=aryExp[j].split(":")[1];
			expObj[k]=v;
		}
		return expObj;
		
	}
	
	function OnLoadConfirm(inRptID) {
		var rptID="";
		if (inRptID!="") rptID=inRptID;
		else{
			var row=$("#rptcfg-loadGrid").datagrid("getSelected");
			rptID=row.ID;
		}
		$cm({
			ClassName:"web.DHCWL.V1.BKCDQry.BaseDataServ",
			MethodName:"GetRptCfgData",
			rptID:rptID
		},function(jsonData){
			//rpt对象
			$.extend( curRptObj, jsonData.rptData[0] );
			curRptObj.DateItemUpdated=false;
			$('#actLabel').html("修改 - "+curRptObj.Name);	
			//1、加载查询对象
			//var a=$("#inputQryObj").val();
			var curQryObj=jsonData.qryData[0];
			//$("#inputQryObj").val(curQryObj.Name);
			$("#inputQryObj").val(curQryObj.Name);
			//2、加载树
			//3、加载统计口径
			refreshTree(curQryObj);
			//4、加载报表列
			var colData=jsonData.colData;
			$("#rptcolGrid").datagrid("loadData",colData);
			
			//5、加载过滤条件

			for(var i=0;i<jsonData.filterData.length;i++) {
				var strExp=jsonData.filterData[i].Exp.toString();
				var expObj=str2Obj(strExp);
				$.extend( jsonData.filterData[i], expObj );
			}
			
			$("#rptfilterGrid").datagrid("loadData",jsonData.filterData);
			//6、排序条件
			for(var i=0;i<jsonData.orderData.length;i++) {
				var strExp=jsonData.orderData[i].Exp.toString();
				var expObj=str2Obj(strExp);
				$.extend( jsonData.orderData[i], expObj );
			}
			$("#rptorderGrid").datagrid("loadData",jsonData.orderData);
			//7、查询条件
			$("#rptquerycondGrid").datagrid("loadData",jsonData.queryconfData);					
			
			//8、加载报表列
			$("#rptrowGrid").datagrid("loadData",jsonData.rowData);			
			//9、交叉汇总
			$("#rptcrossGrid").datagrid("loadData",jsonData.crossData);			


			$("#rptcolGrid").datagrid('enableDnd');
			$("#rptorderGrid").datagrid('enableDnd');

			$("#rptrowGrid").datagrid('enableDnd');
			$("#rptcrossGrid").datagrid('enableDnd');


			
		});				

		
	}	

	
	
	
	

	if (showType=="网格报表") {
		var tabs=$('#rptcfgTab').tabs('tabs')

		$('#rptcfgTab').tabs('close',"报表行");
		$('#rptcfgTab').tabs('close',"交叉汇总");
		
		
		$('#rptcolGrid').datagrid("showColumn",'Format');
	}else{
		$('#rptcfgTab').tabs('close',"排序");
		
	}
	
	
	
	
	if (inAct=="edit") {
		$('#actLabel').html("修改");
		OnLoadConfirm(rptID);
	}else if  (inAct=="add") {
		$('#actLabel').html("新增");
		//报表对象
		curRptObj={
			Code:"",
			Name:"",
			ID:"",
			DateItemCode:"",
			showType:showType
		};
		//查询对象
		$("#inputQryObj").val("");
		//树，统计口径					
		refreshTree({ID:""});
		
		$('#DataItem').combobox("setValue","");
		
		//清空grid数据	
			
		$('#itemcfg').panel('setTitle',"当前配置报表：");
		/*
		$("#rptcolGrid").datagrid("loadData",[]);
		$("#rptfilterGrid").datagrid("loadData",[]);
		$("#rptorderGrid").datagrid("loadData",[]);
		$("#rptquerycondGrid").datagrid("loadData",[]);						
		$("#rptrowGrid").datagrid("loadData",[]);		
		$("#rptcrossGrid").datagrid("loadData",[]);	
		*/
		
		//OnLoadConfirm();
	}else if  (inAct=="") {
		//OnLoadConfirm();
	}
	
		
	
}
	////////////////////////////////////////////////////////////////////////////////
	//过滤字符串更新

init.refreshFilterStr=function(){
		//$("#filterString").text("Hello world!");
		var filterItems=$("#rptfilterGrid").datagrid('getRows');
		var fstr="";
		for(var i=0;i<filterItems.length;i++){
			
			if(filterItems[i].Code==""){
				fstr=fstr+filterItems[i].logical;
			}else if(filterItems[i].Relational=="between"){
				fstr=fstr+filterItems[i].logical+" "+filterItems[i].Code+" "+filterItems[i].Relational+" "+filterItems[i].V1+" and "+filterItems[i].V2;
			}else if(filterItems[i].Relational=="like") {
				fstr=fstr+filterItems[i].logical+" "+filterItems[i].Code+" "+filterItems[i].Relational+" ( "+filterItems[i].V1+" )";
			}else{
				fstr=fstr+filterItems[i].logical+" "+filterItems[i].Code+" "+filterItems[i].Relational+" "+filterItems[i].V1;
			}
			fstr=fstr+" ";
			
		}
		$("#filterString").text(fstr);
	}

///编辑
init.editRptItem=function(gridSelector,ID,funCallback) {
	//alert("editItem "+inx);	
	var index=$(gridSelector).datagrid("getRowIndex",ID);
	if (init[gridSelector].editID != ID){
		if (init.endEditing(gridSelector,ID)){
			$(gridSelector).datagrid('selectRow', index).datagrid('beginEdit', index);
			init[gridSelector].editID = ID;
		} else {
			$(gridSelector).datagrid('selectRow', index);
		}
	}
	else if (init[gridSelector].editID == ID){
		if (init.endEditing(gridSelector,ID)){
		} else {
			$(gridSelector).datagrid('selectRow', index);
		}
	}		
	
	
	
			
};	

///结束编辑
init.endEditing=function(gridSelector,ID){
	if (init[gridSelector].editID == undefined){return true}
	//var editIndex=$(gridSelector).datagrid("getRowIndex",ID);
	var editIndex=$(gridSelector).datagrid("getRowIndex",init[gridSelector].editID);
	if ($(gridSelector).datagrid('validateRow', editIndex)){
		$(gridSelector).datagrid('endEdit',editIndex);
		init[gridSelector].editID = undefined;
		return true;                                                                                
	} else {
		return false;                                                                               
	}                                                                                             
} 

//删除
init.removeRptItem=function(gridSelector,ID,funCallback) {
	var colIndex=$(gridSelector).datagrid("getRowIndex",ID);
	$(gridSelector).datagrid("deleteRow",colIndex);
	//refreshFilterStr();
	if (funCallback!=null) {
		funCallback();
		//"#rptfilterGrid";
	}
}
//init.editID=undefined;
init["#rptcolGrid"]={editID:undefined};
init["#rptfilterGrid"]={editID:undefined};
init["#rptorderGrid"]={editID:undefined};
init["#rptcrossGrid"]={editID:undefined};
$(init);

