// /名称: 药品信息维护
// /描述: 药品信息维护
// /编写者：zhangdongmei
// /编写日期: 2011.12.16
// /修改：2012-06-14，调整布局
var drugRowid = "";
var storeConRowId="";
var SaveAsFlag="";
var gNewCatIdOther="";
var changeflag="";
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
if(gParamCommon.length<1){
   GetParamCommon();  //初始化公共参数配置 wyx 公共变量取类组设置gParamCommon[9]公共变量取进价规则设置gParamCommon[7]
 }
Ext.onReady(function() {		
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		//============================DrugList.js====================================================================
		//==========函数==========================
		/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var InciCode=record.get("InciCode");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("M_InciDesc").setValue(InciDesc);
			Ext.getCmp("M_InciCode").setValue(InciCode);
			
			search();
		}
		/*
		//右键菜单代码关键部分 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
		
		function editIncAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要编辑的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				IncAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editArcAliasInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要编辑的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				OrdAliasEdit(DrugInfoStore, IncRowid);								
			}
		}
		function editDoseEquivInfo() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要编辑的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var IncRowid = selectedRow.get("InciRowid");
				DoseEquivEdit(DrugInfoStore, IncRowid);								
			}
		}
		*/

		//==========函数==========================
		
		//==========控件==========================
		// 药品编码
		var M_InciCode = new Ext.form.TextField({
			fieldLabel : '<font color=blue>药品编码</font>',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});
		// 药品名称
		var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '<font color=blue>药品名称</font>',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("M_StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});
	
		// 药品别名
		var M_GeneName = new Ext.form.TextField({
			fieldLabel : '<font color=blue>药品别名</font>',
			id : 'M_GeneName',
			name : 'M_GeneName',
			anchor : '90%',
			valueNotFoundText : '',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						search();
					}
				}
			}
		});

		// 药品类组
		var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
			fieldLabel:'<font color=blue>类　　组</font>',
			id : 'M_StkGrpType',
			name : 'M_StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			UserId:userId,
			//LocId:gLocId,
			anchor : '90%'
		}); 
		M_StkGrpType.on('change',function(){
			Ext.getCmp("M_StkCat").setValue('');
		});
		
		// 库存分类
		var M_StkCat = new Ext.ux.ComboBox({
			fieldLabel : '<font color=blue>库存分类</font>',
			id : 'M_StkCat',
			name : 'M_StkCat',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'M_StkGrpType'}
		});
		var PHCCATALLOTH = new Ext.form.TextField({
			fieldLabel : '药学分类',
			id : 'PHCCATALLOTH',
			name : 'PHCCATALLOTH',
			anchor : '90%',
			readOnly : true,
			valueNotFoundText : ''
		});
		function GetAllCatNewList(catdescstr,newcatid){
			//if ((catdescstr=="")&&(newcatid=="")) {return;}
			Ext.getCmp("PHCCATALLOTH").setValue(catdescstr);
			gNewCatIdOther=newcatid;
	
	
		}
		/// 药学分类
		var PHCCATALLOTHButton = new Ext.Button({
			id:'PHCCATALLOTHButton',
			text : '...',
			handler : function() {	
				PhcCatNewSelect(gNewCatIdOther,GetAllCatNewList)
		    }
		});

		// 全部
		var M_AllFlag = new Ext.form.Checkbox({
			fieldLabel : '全　　部',
			id : 'M_AllFlag',
			name : 'M_AllFlag',
			//anchor : '90%',
			checked : false
		});

		// 另存为
		var M_SaveAsFlag = new Ext.form.Checkbox({
			fieldLabel : '另　　存',
			id : 'M_SaveAsFlag',
			name : 'M_SaveAsFlag',
			//anchor : '90%',
			checked : false,
			handler:function(){
				SaveAsFlag=Ext.getCmp("M_SaveAsFlag").getValue();
			}
		});
		//==========控件==========================
	
		// 访问路径
		var DspPhaUrl ='dhcst.druginfomaintainaction.csp?actiontype=GetItm';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
			url:DspPhaUrl,
			method : "POST"
		});
		// 指定列参数
		var fields = ["InciRowid", "InciCode", "InciDesc", "Spec", "Manf","PurUom", "Sp", "BUom", "BillUom", "Form", "GoodName","GenericName", "StkCat","NotUseFlag","PhaCatAllDesc","StkGrpDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "InciRowid",
			fields : fields
		});
	    
		// 数据集
		var DrugInfoStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
		});


		// 添加排序方式
		DrugInfoStore.setDefaultSort('InciRowid', 'ASC');
	
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				clearData();
				search();
			}
		});

		function search(){
			var inciDesc = Ext.getCmp("M_InciDesc").getValue();
			var inciCode = Ext.getCmp("M_InciCode").getValue();
			var alias = Ext.getCmp("M_GeneName").getValue();
			var stkCatId = Ext.getCmp("M_StkCat").getValue();
			var PhcCatId ="" ;
			var PhcSubCatId = "";
			var PhcMinCatId ="";
			var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
			if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
				Msg.info("error", "请选择查询条件!");
				return false;
			}
			var allFlag = (Ext.getCmp("M_AllFlag").getValue()==true?'Y':'N');
			var others = ""+"^"+""+"^"+""+"^"+StkGrpType+"^"+gNewCatIdOther;
			var strParam=inciDesc+RowDelim+inciCode+RowDelim+alias+RowDelim+stkCatId+RowDelim+allFlag+RowDelim+others
			DrugInfoStore.setBaseParam("Params",strParam);
			// 分页加载数据
			DrugInfoStore.load({params:{start:0, limit:DrugInfoGridPagingToolbar.pageSize},
				callback : function(r,options, success) {					//Store异常处理方法二
				debugger
					if(success==false){ 
						Ext.MessageBox.alert("查询错误",this.reader.jsonData.Error); 
     				}else{
	     				var rowCount=DrugInfoStore.getCount()
     					//只有一条记录的话选中此记录
     					if(r.length>=1){
     						DrugInfoGrid.getSelectionModel().selectFirstRow();
     						DrugInfoGrid.fireEvent('rowclick',this,0);
     					}
     				}        				
				}
			});
			//=======通过上下键选取时获取焦点===
			 DrugInfoStore.on('load',function(){
			if (DrugInfoStore.getCount()>0){
		      DrugInfoGrid.getSelectionModel().selectFirstRow();
		      DrugInfoGrid.getView().focusRow(0);
	        }
				})
			//=======通过上下键选取时获取焦点===
		}
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '清屏',
			tooltip : '点击清屏',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				M_InciCode.setValue("");
				M_InciDesc.setValue("");
				M_StkGrpType.setValue("");
				M_StkCat.setValue("");
				M_StkGrpType.setRawValue("");
				M_StkCat.setRawValue("");
				M_GeneName.setValue("");
				M_AllFlag.setValue(false);
				M_SaveAsFlag.setValue(false);				
				DrugInfoGrid.getStore().removeAll();
				DrugInfoGrid.getView().refresh();
				drugRowid="";
				Ext.getCmp("PHCCATALLOTH").setValue("");
				gNewCatIdOther=""
				clearData();
                DrugInfoStore.setBaseParam('Params',"")
                DrugInfoStore.load({
					params:{start:0,limit:0},			
					callback : function(r,options, success) {					
						if(success==false){
		 					Ext.MessageBox.alert("查询错误",DrugInfoStore.reader.jsonData.Error);  
		 				}         				
					}
				});	
			}
		});
		
		var nm = new Ext.grid.RowNumberer();
		/*
		var ColumnNotUseFlag = new Ext.grid.CheckColumn({
			id:'NotUseFlag',
       		header: '不可用',
       		dataIndex: 'NotUseFlag',
       		sortable : true,
       		disabled:true,
       		width: 45
    	}); */
		
		var DrugInfoCm = new Ext.grid.ColumnModel([nm, 
			{
				header : "库存项id",
				dataIndex : 'InciRowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '名称',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PurUom',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "售价(入库单位)",
				dataIndex : 'Sp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "计价单位",
				dataIndex : 'BillUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'Form',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "商品名",
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "通用名",
				dataIndex : 'GenericName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'StkCat',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'StkGrpDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "药学分类",
				dataIndex : 'PhaCatAllDesc',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "不可用",
				dataIndex : 'NotUseFlag',
				width : 45,
				align : 'center',
				renderer : function(v) {
					if (v == "Y")
						return "<div class='ux-lovcombo-icon-checked ux-lovcombo-icon' style='background-position:0 -13px;'>&nbsp;</div>";
					else
						return "<div class='ux-lovcombo-icon-unchecked ux-lovcombo-icon'>&nbsp;</div>"
				},
				sortable : true
			}
		]);
		DrugInfoCm.defaultSortable = true;
		

		var DrugInfoGridPagingToolbar = new Ext.PagingToolbar({
			store : DrugInfoStore,
			pageSize : 10,
			displayInfo : true,
			displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
			emptyMsg : "No results to display",
			prevText : "上一页",
			nextText : "下一页",
			refreshText : "刷新",
			lastText : "最后页",
			firstText : "第一页",
			beforePageText : "当前页",
			afterPageText : "共{0}页",
			emptyMsg : "没有数据"
		});

		var DrugInfoGrid = new Ext.grid.GridPanel({
			id:'DrugInfoGrid',
			region:'center',
			//height:420,
			//width : 495,
			autoScroll:true,
			cm:DrugInfoCm,
			store:DrugInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask : true,
			//plugins: [ColumnNotUseFlag],
			bbar:[DrugInfoGridPagingToolbar],
			tbar:{items:[{iconCls:'page_gear',text:'列设置',handler:function(){	GridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAIN");}}]}//,
			/*view: new Ext.ux.grid.BufferView({
			    rowHeight: 30,
			    // forceFit: true,
			    scrollDelay: false
			})*/
		});
		
		var HisListTab = new Ext.form.FormPanel({
			height:DHCSTFormStyle.FrmHeight(4),
			labelWidth: 60,	
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			region : 'north',	
			autoHeight:true,
			tbar : [SearchBT, '-', ClearBT],
			items:[{
				xtype:'fieldset',
				title:'查询条件--<font color=red>类组、库存分类、药品编码、药品名称、药品别名不能全部为空</font>',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:DHCSTFormStyle.FrmPaddingV,
				defaults: {border:false},
				items : [{ 				
					columnWidth: 0.5,
	            	xtype: 'fieldset',	            	
	            	items: [M_InciCode,M_InciDesc,M_StkGrpType,M_StkCat]					
				}, {
					columnWidth: 0.5,
	            	xtype: 'fieldset',
					items : [{xtype:'compositefield',items:[PHCCATALLOTH,PHCCATALLOTHButton]},M_GeneName,M_SaveAsFlag,M_AllFlag]
				}]					
			}]			
		});
		// 添加表格选取行事件
	DrugInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			drugRowid = InciRowid;
			//查询三大项信息
			if (InciRowid == null || InciRowid.length <= 0 || InciRowid <= 0) {
				return false;
			}
			
			GetDetail(drugRowid);
	});
		//======Grid点击事件===================================
		DrugInfoGrid.on('rowclick',function(grid,rowIndex,e){
			var selectedRow = DrugInfoStore.data.items[rowIndex];
			var InciRowid = selectedRow.data['InciRowid'];
			drugRowid = InciRowid;
			//查询三大项信息
			if (InciRowid == null || InciRowid.length <= 0 || InciRowid <= 0) {
				return false;
			}			
			GetDetail(drugRowid);
		});

		
		/***
		**添加右键菜单,zdm,2012-01-04***
		**/
		/*
		DrugInfoGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuInciAlias', 
					handler: editIncAliasInfo, 
					text: '库存项别名' 
				},{ 
					id: 'mnuArcAlias', 
					handler: editArcAliasInfo, 
					text: '医嘱项别名' 
				},{ 
					id: 'mnuDoseEquiv', 
					handler: editDoseEquivInfo, 
					text: '等效数量' 
				}
			] 
		}); 
		*/
		//======Grid点击事件===================================
		
		RefreshGridColSet(DrugInfoGrid,"DHCSTDRUGMAINTAIN");   //根据自定义列设置重新配置列               
		
		var viewport = new Ext.Viewport({
            layout: 'border',
            items: [
			{
                region: 'center',
                title: '药品列表',
                id:'DrugList',
                collapsible: true,
                //split: true,
                margins: '0 5 0 0',
                layout: 'border',                
                items : [HisListTab,DrugInfoGrid]          // this TabPanel is wrapped by another Panel so the title will be applied
           
            },
            {
	            region: 'east',
                split: true,
                width: 775, // give east and west regions a width
                minSize: 300,
                maxSize: 1200,
                margins: '0 5 0 0',
                layout: 'fit',                 
                items : [talPanel] 
       		
       		}]
        });
    InitDetailForm();
})