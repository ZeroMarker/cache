
function InitVpInfPatientAdm(){
	var obj = new Object();
	
	obj.gridDeathPatientStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridDeathPatientStore = new Ext.data.Store({
		proxy: obj.gridDeathPatientStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Paadm'
		},  
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'MrNo',mapping: 'MrNo'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'DecDate', mapping: 'DecDate'}
			,{name: 'DecTime', mapping: 'DecTime'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'Room', mapping: 'Room'}
			,{name: 'Bed', mapping: 'Bed'}
			,{name: 'DoctorName', mapping: 'DoctorName'}
			,{name: 'Department', mapping: 'Department'}
			,{name: 'Ward', mapping: 'Ward'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'ChRepID',mapping: 'ChRepID'}
			,{name: 'ChRepDate',mapping: 'ChRepDate'}
			,{name: 'ChRepTime',mapping: 'ChRepTime'}
			,{name: 'ChRepUser',mapping: 'ChRepUser'}
			,{name: 'ChRepStatus',mapping: 'ChRepStatus'}
			,{name: 'ChRepLocID',mapping: 'ChRepLocID'}
			,{name: 'ChRepLoc',mapping: 'ChRepLoc'}
			,{name: 'ReportID', mapping: 'ReportID'}
			,{name: 'RepDate',mapping: 'RepDate'}
			,{name: 'RepTime',mapping: 'RepTime'}
			,{name: 'RepUser',mapping: 'RepUser'}
			,{name: 'RepStatus',mapping: 'RepStatus'}
			,{name: 'RepLocID',mapping: 'RepLocID'}
			,{name: 'RepLoc',mapping: 'RepLoc'}
			
		])
	});
	obj.gridDeathPatient = new Ext.grid.GridPanel({
		id : 'gridDeathPatient'
		,store : obj.gridDeathPatientStore
		,buttonAlign : 'center'
		,region : 'center'
		,loadMask:{msg:"正在加载数据，请稍候...."}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: true}
			,{header: '患儿姓名', width: 70, dataIndex: 'PatientName', sortable: true}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: true}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: true}
			,{header: '就诊<br>类型', width: 40, dataIndex: 'AdmType', sortable: true}
			,{header: '死亡日期', width: 80, dataIndex: 'DecDate', sortable: true}
			,{header: '死亡<br>时间', width: 50, dataIndex: 'DecTime', sortable: true}
			,{header: '死亡<br>证明书', width : 60, dataIndex : 'ReportID'
				, renderer: function(v, m, rd, r, c, s){
					var strRet = "";
					var Paadm    = rd.get("Paadm");
					var ReportID = rd.get("ReportID");
                    if (ReportID!=='') {
						var RepDate=rd.get("RepDate");
						var RepTime=rd.get("RepTime");
						var RepUser=rd.get("RepUser");
						var RepStatus=rd.get("RepStatus");
						var altInfo="死亡证明书，报告时间:" + RepDate + " " + RepTime + ",报告人:" + RepUser + ",状态:" + RepStatus
						//fix bug 135422 by pylian 2015-09-30 鼠标放在图片上不显示图片名称、状态
						strRet += "<A id='lnkDMReport' HREF='#' onClick='DeathReportLookUpHeader(\"" + ReportID + "\",\"" + Paadm + "\")' ><img name='lnkDMReport' src='../images/webemr/reports.gif' alt='" + altInfo + "' title='" + altInfo + "'  /></A>";
					} else {
						strRet += "<A id='lnkDMReport' HREF='#' onClick='DeathReportLookUpHeader(\"" + ReportID + "\",\"" + Paadm + "\")' ><img name='lnkDMReport' src='../images/webemr/Deceased.gif' alt='新建死亡报告' title='新建死亡报告'  /></A>";
					}
					return strRet;
				}
			},
			{header: '儿童死亡<br>报卡', width : 60, dataIndex : 'ReportID'
				, renderer: function(v, m, rd, r, c, s){
					var strRet = "";
					var Paadm    = rd.get("Paadm");
					var ReportID = rd.get("ReportID");
					var ChRepID  = rd.get("ChRepID");
					var Status=rd.get("RepStatus");
                    if (ChRepID != '') {
						var RepDate=rd.get("ChRepDate");
						var RepTime=rd.get("ChRepTime");
						var RepUser=rd.get("ChRepUser");
						var RepStatus=rd.get("ChRepStatus");
						
						var altInfo="儿童死亡报卡，报告时间:" + RepDate + " " + RepTime + ",报告人:" + RepUser + ",状态:" + RepStatus
						strRet += "<A id='lnkDMCReport' HREF='#' onClick='DeathReportChildLookUpHeader(\"" + ReportID + "\",\"" + Paadm + "\",\"" + ChRepID + "\",\""+Status+"\")' ><img name='lnkDMCReport' src='../images/webemr/reports.gif' alt='" + altInfo + "' title='" + altInfo + "' /></A>";
					} else {
						strRet += "<A id='lnkDMCReport' HREF='#' onClick='DeathReportChildLookUpHeader(\"" + ReportID + "\",\"" + Paadm + "\",\"" + ChRepID + "\",\""+Status+"\")' ><img name='lnkDMCReport' src='../images/webemr/Deceased.gif' alt='新建儿童死亡报卡' title='新建儿童死亡报卡' /></A>";
					}
					return strRet;
				}
			}
			,{header: '状态', width:40, dataIndex:'ChRepStatus'}
			,{header: '报告日期', width:80, dataIndex:'ChRepDate'}
			,{header: '报告时间', width:60, dataIndex:'ChRepTime'}
			,{header: '报告人', width:70, dataIndex:'ChRepUser'}
			,{header: '报告科室', width:70, dataIndex:'ChRepLoc'}
			,{header: '入院日期', width: 80, dataIndex: 'AdmitDate', sortable: true}
			,{header: '出院日期', width: 80, dataIndex: 'DisDate', sortable: true}
			,{header: '主管医生', width: 80, dataIndex: 'DoctorName', sortable: true}
			,{header: '科室', width: 120, dataIndex: 'Department', sortable: true}
			,{header: '病区', width: 120, dataIndex: 'Ward', sortable: true}
		]
		,viewConfig : {
			// forceFit : true
			enableRpwBody : true,
			showPreview : true,
			layout : function() {
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
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"DTH");
    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","科室","","","","cboSSHosp");//fix by pylian 108558 科室下面不显示急诊科 
   //fix by maxiangping 190269 添加查询日期类型
    obj.cboDateType = new Ext.form.ComboBox({
		id : 'cboDateType'
		,fieldLabel : '日期类型'
		,mode: 'local'
		,anchor:'98%'
		,triggerAction : 'all'
    	,store: new Ext.data.ArrayStore({
        	fields: ['key', 'text'],
        	data: [["1", '报告日期'], ["2", '死亡日期']]
    	}),
    	valueField: 'key',
    	displayField: 'text'
	});
	Common_SetValue("cboDateType","1","报告日期");
    obj.txtDateFrom = Common_DateFieldToDate("txtDateFrom","开始日期");
    obj.txtDateTo = Common_DateFieldToDate("txtDateTo","结束日期");
	obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtMrNo = Common_TextField("txtMrNo","病案号");
	obj.txtRegNo = Common_TextField("txtRegNo","登记号");
	//add by pylian 108577 加入监听，输入【登记号】回车不能自动补零 
	obj.txtRegNo.on('specialKey', function(field, e){   
			 // 监听回车按键   
                 if (e.getKey() == Ext.EventObject.ENTER) {//响应回车  
                            obj.txtRegNoENTER();//处理回车事件  
                 }
            });  
            
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width : 60
		,text : '查询'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'north',
						height: 60,
						layout : 'form',
						//frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 210
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboSSHosp]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboDateType]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtDateFrom]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtDateTo]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width : 210
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboRepLoc]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtPatName]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtMrNo]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtRegNo]
									},{
										width : 50
									},{
										width : 70
										,layout : 'form'
										,items: [obj.btnFind]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridDeathPatient
						]
					}
				]
			}
		]
	});
	
	obj.gridDeathPatientStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.DTHService.ReportChildSrv';
		param.QueryName = 'QryDeathPatients';
		param.Arg1 = obj.cboDateType.getValue();
		param.Arg2 = obj.txtDateFrom.getRawValue();
		param.Arg3 = obj.txtDateTo.getRawValue();
		param.Arg4 = obj.cboRepLoc.getValue();
		param.Arg5 = obj.cboSSHosp.getValue();
		param.Arg6 = obj.GetExamConditions();
		param.Arg7 = "^";
		param.ArgCnt = 7;
	});
	
	InitVpInfPatientAdmEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
