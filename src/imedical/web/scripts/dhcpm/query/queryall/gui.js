//Create by dongzt
// 2015014
//需求综合查询
function InitViewport()
{
	var obj = new Object();
	
	obj.cboDateType = Common_ComboToDateType1("cboDateType","日期类型","创建日期");
	obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
	obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	
	obj.cboDemLoc = Common_ComboLoc("cboDemLoc","科室","全院");
	obj.cboDemStatus = Common_ComboToDic("cboDemStatus","需求状态","Improvement","");
	obj.cboDemUser = Common_ComboUser("cboDemUser","创建者","全院");
	obj.cboDemType = Common_ComboToDic("cboDemType","需求类型","Type","");
	obj.cboDemEmerg = Common_ComboToDic("cboDemEmerg","紧急程度","Emergency","");
	
	obj.cboDemDirect = Common_ComboToDemDirect("cboDemDirect","需求方向","HIS需求");

	obj.txtRegNo = new Ext.form.TextField({
		id : 'txtRegNo'
		,fieldLabel : '登记号'
		,anchor : '98%'
	});
	obj.txtMrNo = new Ext.form.TextField({
		id : 'txtMrNo'
		,fieldLabel : '病案号'
		,anchor : '98%'
	});
	obj.txtPatName = new Ext.form.TextField({
		id : 'txtPatName'
		,fieldLabel : '姓名'
		,anchor : '98%'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,text : '查询'
	})
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,width : 80
		,text : '导出'
	});
	
	
	
	
	
	obj.gridPMQueryAllStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridPMQueryAllStore = new Ext.data.Store({
		proxy: obj.gridPMQueryAllStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			
		}, 
		[
			{name: 'DemandID', mapping : 'DemandID'}
			,{name: 'DemandType', mapping : 'DemandType'}
			,{name: 'MenuName', mapping: 'MenuName'}
			,{name: 'UserName', mapping: 'UserName'}
			,{name: 'UserPhone', mapping: 'UserPhone'}
			,{name: 'LocName', mapping: 'LocName'}
			,{name: 'DemondCode', mapping: 'DemondCode'}
			,{name: 'DemandDesc', mapping: 'DemandDesc'}
			,{name: 'EmergDegree', mapping: 'EmergDegree'}
			,{name: 'DemandStatus', mapping: 'DemandStatus'}
			,{name: 'DCreateDate', mapping: 'DCreateDate'}
			,{name: 'DCreateTime', mapping: 'DCreateTime'}
			,{name: 'DEndDate', mapping: 'DEndDate'}
			,{name: 'DEndTime', mapping: 'DEndTime'}
			,{name: 'AdjunctFlag', mapping: 'AdjunctFlag'}
			,{name: 'PMModule', mapping: 'PMModule'}
			,{name: 'DemSituation', mapping: 'DemSituation'}
			,{name: 'EditDemDesc', mapping: 'EditDemDesc'}
			,{name: 'EditUser', mapping: 'EditUser'}
			
		]),
		sortInfo: {field: 'DemondCode',direction: 'Asc'}
	});
	
	
	var pagingToolbar = new Ext.PagingToolbar
	({
      emptyMsg:"没有数据",
      displayInfo:true,
      displayMsg:"显示从{0}条数据到{1}条数据，共{2}条数据",
      store:obj.gridPMQueryAllStore,
      pageSize:50
	});
	obj.gridPMQueryCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });//Modified By LiYang 2013-01-07 增加选择框，以供导出接口
	
	//
	obj.gridPMQueryAll = new Ext.grid.GridPanel({
		id : 'gridPMQueryAll'
		,store : obj.gridPMQueryAllStore
		,plugins : obj.gridPMQueryCheckCol
		,region : 'center'
		,columnLines : true
		,loadMask : true
		//,sm: new Ext.grid.RowSelectionModel({ singleSelect: true })
		,columns: [
			obj.gridPMQueryCheckCol   //Modified By LiYang 2013-01-07 增加选择框，以供导出接口
			,new Ext.grid.RowNumberer()
			,{header : "操作",width : 100,dataIndex : 'addRec',align : 'center'
			,renderer: function (value, metaData, record, rowIndex, colIndex, store) 
			{  
				//var formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='PMDescription'><img src='../scripts/dhcmed/img/export.png'/></a>";  
				//var formatStr = formatStr+" "+"<a href='javascript:void({1});' onclick='javscript:return false;' class='PMEdit'><img src='../scripts/dhcmed/img/edit.gif'/></a>";
				var strRet = "";
				
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false; ' class='PMRecInsert'>添加沟通记录</a>";
	
							strRet = "<div style='color:red;font-weight:bold' class='RecInsert' >" + formatStr + "</div>";
				
					return strRet;
 
			}
			}
			,{header : '需求类型', width : 90, dataIndex : 'DemandType', sortable: false, menuDisabled:true, align:'center' }
			,{header : '菜单名称', width : 80, dataIndex : 'MenuName', sortable: true, menuDisabled:false, align:'center' }
			,{header : '创建者', width : 60, dataIndex : 'UserName', sortable: true, menuDisabled:true, align:'center' }
			,{header : '联系<br>电话', width : 80, dataIndex : 'UserPhone', sortable: true, menuDisabled:true, align:'center' }
			,{header : '科室', width : 150, dataIndex : 'LocName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '需求代码', width : 80, dataIndex : 'DemondCode', sortable: true, menuDisabled:true, align:'center' }
			,{header : '需求名称', width : 250, dataIndex : 'DemandDesc', sortable: true, menuDisabled:true, align:'center' }
			,{header : '紧急程度', width : 80, dataIndex : 'EmergDegree', sortable: true, menuDisabled:true, align:'center' }
			,{header : '需求状态', width : 50, dataIndex : 'DemandStatus', sortable: true, menuDisabled:true, align:'center' }
			,{header : '创建日期', width : 80, dataIndex : 'DCreateDate', sortable: true, menuDisabled:true, align:'center' }
			,{header : '创建时间', width : 80, dataIndex : 'DCreateTime', sortable: true, menuDisabled:true, align:'center' }
			,{header : '完成日期', width : 80, dataIndex : 'DEndDate', sortable: true, menuDisabled:true, align:'center' }
			,{header : '完成时间', width : 80, dataIndex : 'DEndTime', sortable: true, menuDisabled:true, align:'center' } 
			,{header : '附件', width : 20, dataIndex : 'AdjunctFlag', sortable: true, menuDisabled:true, align:'center' }
	
		]
		,bbar:pagingToolbar
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
			,getRowClass : function(record,rowIndex,rowParams,store){
				if ((record.data.DemandStatus=='保存')||(record.data.DemandStatus=='提交')){
					//return 'x-grid-record-font-red';
					return 'x-grid-record-font-wathet';
				} else if(record.data.DemandStatus=='测试'){
					return 'x-grid-record-font-hyacinth';
				} else if(record.data.DemandStatus=='审核不通过'){
					return 'x-grid-record-font-peony';
				} else if(record.data.DemandStatus=='分配'){
					return 'x-grid-record-font-purple';
				} else if(record.data.DemandStatus=='审核1'){
					return 'x-grid-record-font-blue';
				} 
			} 
			
		}
		
    });
	/* ,getRowClass : function(record,rowIndex,rowParams,store){
				if ((record.data.ReportStatusCode='0')||(record.data.ReportStatusCode='1')) {
					return 'x-grid-record-font-red';
				} else {
					return '';
				}
			} */
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.gridPMQueryAll,
			{
				layout : 'form',
				region : "north",
				height : 90,
				frame : true,
				buttonAlign : 'center',
				title : '需求进行情况查询',
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDateType
								]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.txtDateFrom
								]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.txtDateTo
								]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemStatus
								]
							},{
								columnWidth:.15,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemDirect
								]
							},{       //obj.cboDemDirect
								width : 5
							},{
								columnWidth:.10,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								items : [
									obj.btnQuery
								]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemLoc
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemUser
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemType
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemEmerg
								]
							},{
								width : 5
							},{
								columnWidth:.20,
								layout : 'form',
								items : [
									obj.btnExport
								]
							}
						]
					}
				]
			}
		]
	});
	obj.gridPMQueryAllStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCPM.Query.PMQueryAll';  //DHCMed.NINFService.Rep.InfReport
		param.QueryName = 'QryAllDemInfo';  //QryRepInfoByDateLoc
		param.Arg1 = Common_GetValue('cboDateType');
		param.Arg2 = Common_GetValue('txtDateFrom');
		param.Arg3 = Common_GetValue('txtDateTo');
		param.Arg4 = Common_GetValue('cboDemLoc');
		
		param.Arg5 = Common_GetValue('cboDemStatus');
		param.Arg6 = Common_GetValue('cboDemType');
		
		param.Arg7 = Common_GetValue('cboDemEmerg');
		param.Arg8 = Common_GetValue('cboDemUser');
		param.Arg9 =Common_GetValue('cboDemDirect');
		
		param.ArgCnt = 9;
	});
	
	obj.gridPMQueryAllStore.removeAll();
		obj.gridPMQueryAllStore.load({params : {start:0,limit:50}});
	InitViewportEvent(obj);
	obj.btnQuery.on("click", obj.btnQuery_click, obj);
	obj.btnExport.on("click", obj.btnExport_click, obj);
	
	obj.gridPMQueryAll.on("rowdblclick", obj.gridPMQueryAll_rowdblclick, obj);
	//提供给子窗体调用,刷新当前页面
	window.WindowRefresh_Handler = obj.WindowRefresh_Handler;
	
	obj.LoadEvent(arguments);
	
	return obj;
	
}



