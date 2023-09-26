Ext.onReady(function() {
	Ext.QuickTips.init();

	var BonusIndexesStore = new Ext.data.Store({
		id : 'BonusIndexesStore',
		proxy : new Ext.data.HttpProxy({
					url : 'dhc.bonus.BonusDataFilterexe.csp?action=listBonusIndexes'
				}),

		reader : new Ext.data.JsonReader({
					autoLoad : true,
					root : 'rows',
					totalProperty : 'results'
				}, ['BonusTargetID', 'BonusTargetCode', 'BonusTargetName',
						'TargetTypeID', 'TargetTypeName']),
		remoteSort : true
	});
	
	var PagingToolbar = new Ext.PagingToolbar({// 分页工具栏
	pageSize : 10,
	store : BonusIndexesStore,
	displayInfo : true,
	displayMsg : '当前显示{0} - {1}，共计{2}',
	emptyMsg : "没有数据"
});
	
	

	
  
	var bonusIndexesPanel = new Ext.grid.GridPanel({
				// title : '奖金指标',
				store : BonusIndexesStore,
				region : 'north',
				height : 220,
                bbar : PagingToolbar,
				columns : [{
							dataIndex : 'BonusTargetID',
							header : 'ID',
							sortable : false,
							width : 100,
							hidden : true
						},

						{
							dataIndex : 'BonusTargetCode',
							header : '指标编码',
							sortable : false,
							width : 100
						}, {
							header : '指标名称',
							sortable : false,
							width : 100,
							dataIndex : 'BonusTargetName'
						}, {
							header : '指标类别',
							sortable : false,
							width : 100,
							dataIndex : 'TargetTypeName'
						}]

			});

	
			
	//bonusIndexesPanel.getView().focusRow(0);
	
	var dataDept = [['1', '开单科室'], ['2', '执行科室'], ['3', '病人科室'], ['4', '开单医生'],
			['5', '执行医生'], ['6', '负责医生']];
	var deptTypeStore = new Ext.data.SimpleStore({
				fields : ['code', 'name'],
				data : dataDept
			});

	var dataCharge = [['1', '门诊'], ['2', '住院'], ['3', '急诊']];
	var chargeTypeStore = new Ext.data.ArrayStore({
				fields : ['code', 'name'],
				data : dataCharge
			});

	var dataPatient = [['1', '自费'], ['2', '医保'], ['3', '新农合']];
	var patientTypeStore = new Ext.data.ArrayStore({
				fields : ['code', 'name'],
				data : dataPatient
			});

	var smDept = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
	var smCharge = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
	var smPatient = new Ext.grid.CheckboxSelectionModel({handleMouseDown:Ext.emptyFn});
	var GridDept = new Ext.grid.GridPanel({
				title : '科室类别',
				// columnLines: true,
				store : deptTypeStore,
				sm : smDept,
				flex : 1,

				columns : [smDept, {
							xtype : 'gridcolumn',
							header : '编码',
							sortable : false,
							width : 60,
							dataIndex : 'code'
						}, {
							xtype : 'gridcolumn',
							header : '名称',
							sortable : false,
							width : 100,
							dataIndex : 'name'
						}]
			});

	var GridCharge = new Ext.grid.GridPanel({
				title : '费用类别',
				store : chargeTypeStore,
				flex : 1,
				sm : smCharge,
				// columnLines: true,
				columns : [smCharge, {
							header : '编码',
							sortable : false,
							width : 60,
							dataIndex : 'code'
						}, {
							header : '名称',
							sortable : false,
							width : 100,
							dataIndex : 'name'
						}]
			});

	var GridPatient = new Ext.grid.GridPanel({
				title : '患者类别',
				// columnLines: true,
				flex : 1,
				sm : smPatient,
				store : patientTypeStore,
				columns : [smPatient, {
							header : '编码',
							sortable : false,
							width : 60,
							dataIndex : 'code'
						}, {

							header : '名称',
							sortable : false,
							width : 100,
							dataIndex : 'name'
						}]
			});

	var assistCompItemsTree = new Ext.Panel({
				flex : 1
			});

	var tree = new Ext.tree.TreePanel({
		// renderTo:'tree-div',
		title : '辅助核算项目',
		flex : 1,
		height : 300,
		useArrows : true,
		autoScroll : true,
		animate : true,
		enableDD : false,
		containerScroll : true,
		checkModel: 'cascade',
		rootVisible : false,
		onlyLeafCheckable:false,
		
		frame : false,
		root : {
			nodeType : 'async'
		},
		loader : new Ext.tree.TreeLoader({
					dataUrl : 'dhc.bonus.BonusDataFilterexe.csp?action=GetJsonStr'
				})//,

//		listeners : {
//			'checkchange' : function(node, checked) {
//				if (checked) {
//					node.getUI().addClass('complete');
//				} else {
//					node.getUI().removeClass('complete');
//				}
//			}
//		}// ,

			 
	});
function   setParentCheckState(node, checked) {
   var parentNode = node.parentNode;
   if (parentNode==""||parentNode==undefined||parentNode.getUI().checkbox==undefined)
   return ;

   if (checked)
   {
   parentNode.getUI().checkbox.checked=checked;
   setParentCheckState(parentNode,checked);
   return;
    }
	
     var childNodes = parentNode.childNodes;
	 var k=0;
     for (var i = 0; i < childNodes.length; i++) 
	 {
      var childNode = childNodes[i];
	  //这样好像不行
     //if(childNode.attributes.checked==checked)
	  if(childNode.getUI().checkbox.checked==checked)
	  {
	   k++;
	   }
	   else
	   {
	     break;
	   }
	 
	   
	   
      //if (!childNode.attributes.checked) 
	  //{
       //  childNode.ui.toggleCheck();
     // }
     }
	   if(k==childNodes.length)
	   {
	   //parentNode.attributes.checked = checked;
	   //parentNode.ui.toggleCheck(checked);
	   
	   parentNode.getUI().checkbox.checked=checked;
	   setParentCheckState(parentNode,checked);
	   }
    }


tree.on('checkchange', function(node, checked) {
node.expand();
node.attributes.checked = checked; //选中单个目标

node.eachChild(function(child)
{
child.ui.toggleCheck(checked);
child.attributes.checked = checked;
child.fireEvent('checkchange', child, checked);
});
setParentCheckState(node,checked);

},tree);
	
	
	
	
	var rootN = tree.getRootNode();// 获取树的根节点

	function setNodeChecked(cNo, arr) {// 遍历节点
		var childnodes = cNo.childNodes;// 获取根节点的子节点
		for (var i = 0; i < childnodes.length; i++) {
			var cNode = childnodes[i];

			if (cNode.hasChildNodes()) {
			   cNode.getUI().checkbox.checked = false;
				setNodeChecked(cNode, arr);// 递归调用
			} else {
				if (arr.indexOf("" + cNode.id + "") >= 0)
				{
					cNode.getUI().checkbox.checked = true;
					setParentCheckState(cNode,true);
					//cNode.attributes.checked = true;
	                //cNode.ui.toggleCheck(true);
				}
				else
				{
					cNode.getUI().checkbox.checked = false;
					//setParentCheckState(cNode,false);
					
					//cNode.attributes.checked = false;
	                //cNode.ui.toggleCheck(false);
				}
			}
		}
	};
	
	
	var CheckedNodes="";
	function getNodeChecked(cNo) {// 遍历节点
		var childnodes = cNo.childNodes;// 获取根节点的子节点
		for (var i = 0; i < childnodes.length; i++) {
			var cNode = childnodes[i];

			if (cNode.hasChildNodes())
			{
				getNodeChecked(cNode);  // 递归调用
			} else 
			{
				if(cNode.getUI().checkbox.checked == true)
				{
				 if(CheckedNodes=="")
				 {
				 	CheckedNodes=cNode.id;
				 }
				 else
				 {
				 	CheckedNodes=CheckedNodes+","+cNode.id;
				 }
				};
			}
		}
	};
	
	
	

	// tree.load();
	tree.getRootNode().expand(true);

	var assistComputePanel = new Ext.Panel({
				title : '辅助核算数据',
				region : 'center',
				layout : {
					type : 'hbox',
					align : 'stretch'
				},
				items : [tree, GridDept, GridCharge, GridPatient]
			});

	function GridSelect(grid, data, arr) {
		var sm = grid.getSelectionModel();
		var arrSel = new Array();
		for (var i = 0; i < data.length; i++) {
			var code = data[i][0];
			if (arr.indexOf(code) >= 0) {
				arrSel.push(i);
			}
		}
		sm.selectRows(arrSel);
	}
    var clickRowBonusId="";
    //保存信息的时候会用到这个id
	
	
	bonusIndexesPanel.on('rowclick', function(Grid, rowIndex, e) {
		var record = BonusIndexesStore.getAt(rowIndex);
		var bonusId = record.data.BonusTargetID;
        clickRowBonusId=bonusId;
		Ext.Ajax.request({
					url : 'dhc.bonus.BonusDataFilterexe.csp?action=GetInfoByID&ID='
							+ bonusId,
					success : function(response) {
						var respStr = response.responseText;
			
						var array = respStr.split('|');
						
						var arrAssistCompItems = array[1].split(',');
						
						//prompt('aaa',array[1].split(','));
						
						var arrDept = array[2].split(',');
						var arrCharge = array[3].split(',');
						var arrPatient = array[4].split(',');

						setNodeChecked(rootN, arrAssistCompItems);

						GridSelect(GridDept, dataDept, arrDept);
						GridSelect(GridCharge, dataCharge, arrCharge);
						GridSelect(GridPatient, dataPatient, arrPatient);
					}
				});
	});

	
	
	
	
	var btnSave = new Ext.Toolbar.Button({
				text : '保存',
				iconCls : 'add',
				width : 50
			});
			
	var tb = new Ext.Toolbar({

				region : 'center',
				items : [
					    {
							xtype : 'tbtext',
							text : '奖金指标',
							width : 57,
							height : 18
						}, 
						{
							xtype : 'tbspacer',
							width : 30
						},
						{xtype:'tbseparator'},
						
						btnSave]
			});
			
    function msgShow(msginfo)
    {
    	 Ext.Msg.show({
			 title : '提示',
			 msg : msginfo,
			 icon : Ext.Msg.INFO,
			 minWidth : 200,
			 buttons : Ext.Msg.OK
			 });
			
    }
    
    
	btnSave.on('click', function() {
        //取checked node 前先把CheckedNodes置为空
		
		if(clickRowBonusId==""||clickRowBonusId==undefined)
		{
			msgShow('请选择奖金指标项！');
			return;
		}
	
		CheckedNodes="";
		getNodeChecked(tree.getRootNode());
		
		if(CheckedNodes=="")
		{
			msgShow('请选择辅助核算项目！');
			return;
		}
		var selCodesDept=getSelectedCodes(smDept);
		if(selCodesDept=="")
		{
			msgShow('请选择科室类别！');
			return;
		}
		var selCodesCharge=getSelectedCodes(smCharge);
		if(selCodesCharge=="")
		{
			msgShow('请选择费用类别！');
			return;
		}
		var selCodesPatient=getSelectedCodes(smPatient);
		if(selCodesPatient=="")
		{
			msgShow('请选择患者类别！');
			return;
		}

			Ext.Ajax.request({
					url : 'dhc.bonus.BonusDataFilterexe.csp?action=SaveInfo&ID='+ clickRowBonusId+'&AssistCompItems='+CheckedNodes+  '&DeptType=' +selCodesDept+ '&ChargeType=' +selCodesCharge+'&PatientType='+selCodesPatient,
					success : function(response) 
					{
						Ext.Msg.alert("提示","保存成功!");
					}
				});

		
			});

	function getSelectedCodes(sm) 
	{
		var selectRecords = sm.getSelections();
		var selectRecordsStr = "";
		for (var i = 0; i < selectRecords.length; i++) {
			if (selectRecordsStr != '')
			{
				//selectRecordsStr = selectRecordsStr + "|"+ selectRecords[i].get('code')+","+selectRecords[i].get('name');
				selectRecordsStr = selectRecordsStr + "|"+ selectRecords[i].get('code');
			} 
			else 
			{
				selectRecordsStr = selectRecords[i].get('code');
			}
		}
		return  selectRecordsStr;
	}
	
	
	var panel = new Ext.Panel({
				layout : 'border',
				tbar : tb,
				items : [bonusIndexesPanel, assistComputePanel],
				// items : [tb],
				align : 'stretch'
			});

	var viewport = new Ext.Viewport({
				layout : 'fit',
				items : [panel]
			});

	viewport.render("mainPanel");
	
	BonusIndexesStore.on('datachanged', function() {
	//这个只会选中,不会促发单击事件
	bonusIndexesPanel.getSelectionModel().selectRow(0); 
	//下面会促发事件，但不会选中，两者结合
	  bonusIndexesPanel.fireEvent('rowclick',bonusIndexesPanel,0);
	
	});
	
	function delayload()
	{
	BonusIndexesStore.load({params : {
					start : 0,
					limit : PagingToolbar.pageSize
				}});
	}
	
	setTimeout(delayload,2000);
				
});