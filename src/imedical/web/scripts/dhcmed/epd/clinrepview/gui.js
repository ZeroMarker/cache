
function InitviewScreen(){
	var obj = new Object();
	
	obj.EpisodeID = EpisodeID;
	obj.PatientID = PatientID;
	
	obj.txtRegNo = new Ext.form.ComboBox({
		id : 'txtRegNo'
		,fieldLabel : '登记号'
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL,
				listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCMed.EPDService.CommonSrv';
						param.QueryName = 'QryAdmByRegNo';
						param.Arg1  = obj.txtRegNo.getRawValue();
						param.ArgCnt    = 1;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'Paadm'
			}, 
			[
				{name: 'Paadm', mapping: 'Paadm'}
				,{name: 'PatientID', mapping: 'PatientID'}
				,{name: 'RegNo', mapping: 'RegNo'}
				,{name: 'PatName', mapping: 'PatName'}
				,{name: 'Sex', mapping: 'Sex'}
				,{name: 'Age', mapping: 'Age'}
				,{name: 'PersonalID', mapping: 'PersonalID'}
				,{name: 'AdmDate', mapping: 'AdmDate'}
				,{name: 'AdmTime', mapping: 'AdmTime'}
				,{name: 'AdmLoc', mapping: 'AdmLoc'}
				,{name: 'AdmType', mapping: 'AdmType'}
				,{name: 'AdmStatus', mapping: 'AdmStatus'}
				,{name: 'DischDate', mapping: 'DischDate'}
				,{name: 'DischTime', mapping: 'DischTime'}
			]),
			sortInfo: {field: 'Paadm',direction: 'ASC'}
		})
		,minChars : 100
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>就诊号</th>',
					'<th>登记号</th>',
					'<th>姓名</th>',
					'<th>性别</th>',
					'<th>年龄</th>',
					'<th>就诊类型</th>',
					'<th>就诊日期</th>',
					'<th>就诊时间</th>',
					'<th>科室</th>',
					'<th>就诊状态</th>',
					//'<th>出院日期</th>',
					//'<th>出院时间</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{Paadm}</td>',
					'<td>{RegNo}</td>',
					'<td>{PatName}</td>',
					'<td>{Sex}</td>',
					'<td>{Age}</td>',
					'<td>{AdmType}</td>',
					'<td>{AdmDate}</td>',
					'<td>{AdmTime}</td>',
					'<td>{AdmLoc}</td>',
					'<td>{AdmStatus}</td>',
					//'<td>{DischDate}</td>',
					//'<td>{DischTime}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:600
		,valueField : 'Paadm'
		,displayField : 'RegNo'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '98%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((!field.getValue())||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	
	obj.txtPatName = new Ext.form.TextField({
		id : 'txtPatName'
		,fieldLabel : '姓名'
		,anchor : '98%'
	});
	
	obj.txtSex = new Ext.form.TextField({
		id : 'txtSex'
		,fieldLabel : '性别'
		,anchor : '98%'
	});
	
	obj.txtAge = new Ext.form.TextField({
		id : 'txtAge'
		,fieldLabel : '年龄'
		,anchor : '98%'
	});
	
	obj.txtAdmType = new Ext.form.TextField({
		id : 'txtAdmType'
		,fieldLabel : '就诊类型'
		,anchor : '98%'
	});
	
	obj.txtAdmStatus = new Ext.form.TextField({
		id : 'txtAdmStatus'
		,fieldLabel : '就诊状态'
		,anchor : '98%'
	});
	
	obj.txtAdmLoc = new Ext.form.TextField({
		id : 'txtAdmLoc'
		,fieldLabel : '科室'
		,anchor : '98%'
	});
	
	obj.txtAdmDate = new Ext.form.TextField({
		id : 'txtAdmDate'
		,fieldLabel : '就诊日期'
		,anchor : '98%'
	});
	
	obj.btnNewRep = new Ext.Button({
		id : 'btnNewRep'
		,iconCls : 'icon-new'
		,width : 70
		,text : '传染病报卡'
	});
	
	obj.gridEpdReportStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridEpdReportStore = new Ext.data.Store({
		proxy: obj.gridEpdReportStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'RowID'
		},[
			{name: 'RowID', mapping : 'RowID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'RegNo', mapping : 'RegNo'}
			,{name: 'PatientName', mapping : 'PatientName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping : 'Age'}
			,{name: 'DiseaseICD', mapping : 'DiseaseICD'}
			,{name: 'DiseaseName', mapping : 'DiseaseName'}
			,{name: 'ReportDep', mapping : 'ReportDep'}
			,{name: 'RepPlace', mapping : 'RepPlace'}
			,{name: 'RepUserCode', mapping : 'RepUserCode'}
			,{name: 'RepUserName', mapping : 'RepUserName'}
			,{name: 'RepDate', mapping : 'RepDate'}
			,{name: 'RepTime', mapping : 'RepTime'}
			,{name: 'Status', mapping : 'Status'}
			,{name: 'Paadm', mapping : 'Paadm'}
			,{name: 'StatusCode', mapping : 'StatusCode'}
			,{name: 'CheckUserCode', mapping : 'CheckUserCode'}
			,{name: 'CheckUserDesc', mapping : 'CheckUserDesc'}
			,{name: 'CheckDate', mapping : 'CheckDate'}
			,{name: 'CheckTime', mapping : 'CheckTime'}
			,{name: 'RepKind', mapping : 'RepKind'}
			,{name: 'RepRank', mapping : 'RepRank'}
			,{name: 'FamName', mapping : 'FamName'}
			,{name: 'Occupation', mapping : 'Occupation'}
			,{name: 'Company', mapping : 'Company'}
			,{name: 'Address', mapping : 'Address'}
			,{name: 'IDAddress', mapping : 'IDAddress'}
			,{name: 'TelPhone', mapping : 'TelPhone'}
			,{name: 'SickDate', mapping : 'SickDate'}
			,{name: 'DiagDate', mapping : 'DiagDate'}
			,{name: 'DeathDate', mapping : 'DeathDate'}
			,{name: 'RepNo', mapping : 'RepNo'}
			,{name: 'PersonalID', mapping : 'PersonalID'}
			,{name: 'DelReason', mapping : 'DelReason'}
			,{name: 'DemoInfo', mapping : 'DemoInfo'}
		])
	});
	obj.gridEpdReport = new Ext.grid.GridPanel({
		id : 'gridEpdReport'
		,store : obj.gridEpdReportStore
		,columnLines : true
		,loadMask : true
		,frame : true
		,region : 'center'
		,height : 240
		,columns: [
			//{header : '登记号', width : 70, dataIndex : 'RegNo', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '姓名', width : 60, dataIndex : 'PatientName', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '性别', width : 50, dataIndex : 'Sex', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '年龄', width : 50, dataIndex : 'Age', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '身份证号', width : 120, dataIndex : 'PersonalID', sortable: false, menuDisabled:true, align:'center' }
			{header : '疾病诊断', width : 80, dataIndex : 'DiseaseName', sortable: false, menuDisabled:true, align:'center', 
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header : '传染病<br>类别', width : 70, dataIndex : 'RepKind', sortable: false, menuDisabled:true, align:'center' }
			,{header : '状态', width : 50, dataIndex : 'Status', sortable: false, menuDisabled:true, align:'center', 
				renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					switch (record.get("Status")) {
						case "退回" :
							strRet = "<div style='color:red'>" + value + "</div>";
							break;
						case "删除" :
							strRet = "<div style='color:red'>" + value + "</div>";
							break;
						case "草稿" :
							strRet = "<div style='color:red'>" + value + "</div>";
							break;
						default :
							strRet = value;
							break;
					}
					return strRet;
				}
			}
			,{header : '删除/退回<br>原因', width : 100, dataIndex : 'DelReason', sortable: false, menuDisabled:true, align:'center', 
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header : '报告科室', width : 70, dataIndex : 'ReportDep', sortable: false, menuDisabled:true, align:'center', 
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header : '职业', width : 80, dataIndex : 'Occupation', sortable: false, menuDisabled:true, align:'center' }
			,{header : '家长姓名', width : 60, dataIndex : 'FamName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '工作单位', width : 100, dataIndex : 'Company', sortable: false, menuDisabled:true, align:'center', 
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header : '现住址', width : 100, dataIndex : 'Address', sortable: false, menuDisabled:true, align:'center', 
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header : '户籍地址', width : 100, dataIndex : 'IDAddress', sortable: false, menuDisabled:true, align:'center', 
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header : '发病日期', width : 70, dataIndex : 'SickDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '诊断日期', width : 70, dataIndex : 'DiagDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告日期', width : 70, dataIndex : 'RepDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '报告人', width : 60, dataIndex : 'RepUserName', sortable: false, menuDisabled:true, align:'center' }
			,{header : '审核日期', width : 70, dataIndex : 'CheckDate', sortable: false, menuDisabled:true, align:'center' }
			,{header : '审核人', width : 60, dataIndex : 'CheckUserDesc', sortable: false, menuDisabled:true, align:'center' }
			
		]
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
		}
    });
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		//,frame : true
		,items:[
			{
				region: 'north',
				height: 160,
				layout : 'form',
				frame : true,
				buttonAlign : 'center',
				title : '传染病报卡提示：<br>1.输入【登记号】，点回车键，在下拉选项中选择当次就诊信息，点【传染病报卡】按钮，填报新的传染病报告；<br>2.输入【登记号】，点回车键，在下拉选项中选择一条就诊信息，在传染病报告列表，双击查看原有报告。',
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtRegNo]
							},{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtPatName]
							},{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtSex]
							},{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtAge]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtAdmType]
							},{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtAdmLoc]
							},{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtAdmDate]
							},{
								columnWidth : .25
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtAdmStatus]
							}
						]
					}
				],
				buttons : [obj.btnNewRep]
			}
			,obj.gridEpdReport
		]
	});
	
	obj.gridEpdReportStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.EPDService.EpidemicSrv';
		param.QueryName = 'QryByPapmi';
		param.Arg1 = obj.PatientID;
		param.ArgCnt = 1;
	});
	
	InitviewScreenEvent(obj);
	obj.LoadEvent();
	return obj;
}