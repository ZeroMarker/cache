var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.QryFlag = 0;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfAdmDateFrom = Common_DateFieldToDate("dfAdmDateFrom","就诊日期");
	obj.dfAdmDateTo = Common_DateFieldToDate("dfAdmDateTo","至");
	obj.dfDisDateFrom = Common_DateFieldToDate("dfDisDateFrom","出院日期");
	obj.dfDisDateTo = Common_DateFieldToDate("dfDisDateTo","至");
	obj.cboLoc = Common_ComboToLoc("cboLoc","科室","E","","","cboHospital");
	obj.cboWard = Common_ComboToLoc("cboWard","病区","W","","","cboHospital");
	obj.dfAdmDateFrom.setValue('');
	obj.dfAdmDateTo.setValue('');
	obj.dfDisDateFrom.setValue('');
	obj.dfDisDateTo.setValue('');
	
	obj.txtMrNo = Common_TextField("txtMrNo","病案号");
	obj.txtRegNo = Common_TextField("txtRegNo","登记号");
	obj.txtCardNo = Common_TextField("txtCardNo","卡号");
	obj.txtPatName = Common_TextField("txtPatName","姓名");
	obj.txtPersonalID = Common_TextField("txtPersonalID","证件号码");
	obj.txtKeyWord = Common_TextField("txtKeyWord","关键词");
	
	obj.txtMrNo.emptyText = '病案号\\条码号';
	obj.txtMrNo.setRawValue(obj.txtMrNo.emptyText);
	obj.txtMrNo.show();
	obj.txtRegNo.emptyText = '登记号';
	obj.txtRegNo.setRawValue(obj.txtRegNo.emptyText);
	obj.txtRegNo.show();
	obj.txtCardNo.emptyText = '卡号';
	obj.txtCardNo.setRawValue(obj.txtCardNo.emptyText);
	obj.txtCardNo.show();
	obj.txtPatName.emptyText = '姓名\\拼音';
	obj.txtPatName.setRawValue(obj.txtPatName.emptyText);
	obj.txtPatName.show();
	obj.txtPersonalID.emptyText = '身份证号\\证件号码';
	obj.txtPersonalID.setRawValue(obj.txtPersonalID.emptyText);
	obj.txtPersonalID.show();
	obj.txtKeyWord.emptyText = '工作单位\\现住址\\户籍地址\\联系人';
	obj.txtKeyWord.setRawValue(obj.txtKeyWord.emptyText);
	obj.txtKeyWord.show();
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 80
		,anchor : '100%'
		,text : '查找'
	});
	
	obj.RowTemplate = new Ext.XTemplate(
		'<div>',
			'<table border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;background-color:#afd3e8;width:100%;">',
				'<tr style="font-size:18px;height:30px;">',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">序号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="8%">批次号</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">操作项目</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">操作日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">操作人</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">接收人</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">撤销标记</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">撤销日期</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="5%">撤销人</td>',
					'<td align="center" style="border:1 solid #FFFFFF;" width="10%">撤销原因</td>',
				'</tr>',
				'<tbody>',
					'<tpl for="Record">',
						'<tr  class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}" style="border-bottom:1px #BDBDBD solid;">',
							'<td align="center" style="border:1 solid #FFFFFF;">{[xindex]}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{BatchNumber}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ItemDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ActDate} {ActTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UserDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{ToUserDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UpdoOperaDesc}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UpdoDate} {UpdoTime}</td>',
							'<td align="center" style="border:1 solid #FFFFFF;">{UpdoUserDesc}</td>',
							'<td align="left" style="border:1 solid #FFFFFF;">{UpdoReason}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>',
		'</div>'
	);
	
	obj.RowExpander = new Ext.ux.grid.RowExpander({
        tpl : new Ext.XTemplate(
			'<div id="divStatusList-{VolID}"></div>'
        )
    });
	
	obj.VolStatusListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.VolStatusListStore = new Ext.data.Store({
		proxy: obj.VolStatusListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolID'
		},[
			{name: 'VolID', mapping : 'VolID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'IdentityCode', mapping: 'IdentityCode'}
			,{name: 'AdmLocDesc', mapping: 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping: 'AdmWardDesc'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'BackDate', mapping: 'BackDate'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'Company', mapping: 'Company'}
			,{name: 'HomeAddress', mapping: 'HomeAddress'}
			,{name: 'RegAddress', mapping: 'RegAddress'}
			,{name: 'RelativeName', mapping: 'RelativeName'}
			,{name: 'ChiefProfessor', mapping: 'ChiefProfessor'}
			,{name: 'Professor', mapping: 'Professor'}
			,{name: 'VistingDoctor', mapping: 'VistingDoctor'}
			,{name: 'ResidentDoctor', mapping: 'ResidentDoctor'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
			,{name: 'PreStatus', mapping: 'PreStatus'}
		])
	});
	obj.VolStatusList = new Ext.grid.GridPanel({
		id : 'VolStatusList'
		,store : obj.VolStatusListStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,loadMask : true
		,columns: [
			{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '证件号码', width: 100, dataIndex: 'IdentityCode', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					return v;
				}
			}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '现住址/户籍地址', width: 120, dataIndex: 'HomeAddress', sortable: false, menuDisabled:true, align: 'left'
				,renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var HomeAddress = rd.get('HomeAddress');
					var RegAddress = rd.get('RegAddress');
					if (HomeAddress != RegAddress) HomeAddress = HomeAddress + '/' + RegAddress;
					return HomeAddress;
				}
			}
			,{header: '工作单位', width: 80, dataIndex: 'Company', sortable: false, menuDisabled:true, align: 'left'
				,renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					return v;
				}
			}
			,{header: MrClass=='O'?'初诊日期':'就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', id:'DischDate', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收日期', width: 80, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前<br>步骤', width: 50, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '上次状态', width: 80, dataIndex: 'PreStatus', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(v, m, rd, r, c, s){
					var VolumeID = rd.get("VolID");
					return "<a href='#' onclick='objScreen.LnkVolStatusWin(\"" + VolumeID + "\");'>" + v + "</a>";
				}
			}
			//Add By LiYang 2016-02-23 病案操作时间线展示
			,{header: '时间线', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center',
				renderer : function(v, m, rd, r, c, s){
					var ret = "<A href='#' onclick='return objScreen.btnTimeLine_onclick(" + rd.get("VolID") + ")'>时间线</A>";
					return ret;
				}
			}
			,{header: MrClass=='O'?'初诊科室':'科室', width: 100, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'
				,renderer: function(v, m, rd, r, c, s){
					m.attr = 'style="white-space:normal"';
					var AdmLocDesc = rd.get('AdmLocDesc');
					var AdmWardDesc = rd.get('AdmWardDesc');
					if (AdmLocDesc != AdmWardDesc) AdmLocDesc = AdmLocDesc + '/' + AdmWardDesc;
					return AdmLocDesc;
				}
			}
			,{header: '科主任', id:'ChiefProfessor', width: 70, dataIndex: 'ChiefProfessor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '主任医师', id:'Professor', width: 70, dataIndex: 'Professor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '主治医师', id:'VistingDoctor', width: 70, dataIndex: 'VistingDoctor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '住院医师', id:'ResidentDoctor', width: 70, dataIndex: 'ResidentDoctor', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '联系人', width: 60, dataIndex: 'RelativeName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '', width: 0, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'}
		]
		,plugins: obj.RowExpander
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.VolStatusListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			//forceFit : true
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'east',
				width: 300,
				layout : 'form',
				frame : true,
				labelAlign : 'right',
				labelWidth : 60,
				items : [
					obj.cboHospital
					,obj.cboMrType
					,obj.txtMrNo
					,obj.txtRegNo
					,obj.txtCardNo
					,obj.txtPatName
					,obj.txtPersonalID
					,obj.txtKeyWord
					,obj.dfAdmDateFrom
					,obj.dfAdmDateTo
					,obj.dfDisDateFrom
					,obj.dfDisDateTo
					,obj.cboLoc
					,obj.cboWard
					,{
						layout : 'fit'
						,buttonAlign : 'center'
						,buttons : [obj.btnQuery]
					}
				]
			}
			,obj.VolStatusList
		]
	});
	
	obj.VolStatusListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.PatientQry';
			param.QueryName = 'QryVolumeList';
			param.Arg1 = obj.GetQueryInput();
			param.ArgCnt = 1;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}