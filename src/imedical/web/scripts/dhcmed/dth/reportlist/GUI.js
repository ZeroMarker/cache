function InitDMReportList(){
    var obj=new Object();
    
    obj.gridDeathReportStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
         url:ExtToolSetting.RunQueryPageURL
    }));
	obj.gridDeathReportStore=new Ext.data.Store({
		proxy:obj.gridDeathReportStoreProxy
		,reader:new Ext.data.JsonReader(
			{
				root:'record'
				,total:'property'
				,idProperty:'RowID'
			}
			,[
				{name:'RowID',mapping:'RowID'}
				,{name:'PatientID',mapping:'PatientID'}
				,{name:'EpisodeID',mapping:'EpisodeID'}
				,{name:'RepNo',mapping:'RepNo'}
				,{name:'DeathNo',mapping:'DeathNo'}
				,{name:'PapmiNo',mapping:'PapmiNo'}
				,{name:'MrNo',mapping:'MrNo'}
				,{name:'PatName',mapping:'PatName'}
				,{name:'Sex',mapping:'Sex'}
				,{name:'Age',mapping:'Age'}
				,{name:'CardType',mapping:'CardType'}
				,{name:'Identify',mapping:'Identify'}
				,{name:'Occupation',mapping:'Occupation'}
				,{name:'RegAddress',mapping:'RegAddress'}
				,{name:'CurrAddress',mapping:'CurrAddress'}
				,{name:'DeathDate',mapping:'DeathDate'}
				,{name:'AReason',mapping:'AReason'}    
				,{name:'BaseReason',mapping:'BaseReason'}
				,{name:'RepUser',mapping:'RepUser'}
				,{name:'RepLoc',mapping:'RepLoc'}
				,{name:'RepDate',mapping:'RepDate'}
				,{name:'RepTime',mapping:'RepTime'}
				,{name:'RepDateTime',mapping:'RepDateTime'}
				,{name:'RepStatusCode',mapping:'RepStatusCode'}
				,{name:'RepStatusDesc',mapping:'RepStatusDesc'}
				,{name:'BackReason',mapping:'BackReason'}
				,{name:'PrintReason',mapping:'PrintReason'}
				,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
				,{name: 'PatLevel', mapping: 'PatLevel'}
			]
		)
	});
    obj.gridDeathReport=new Ext.grid.GridPanel({
          id:'gridDeathReport'
         ,region:'center'
         ,height:200
         ,store:obj.gridDeathReportStore
         ,loadMask:{msg:"正在加载数据，请稍候...."}
         ,columns:[
             new Ext.grid.RowNumberer()
            ,{header:'登记号',width:80,dataIndex:'PapmiNo',sortable:true}
            ,{header:'病案号',width:80,dataIndex:'MrNo',sortable:true}
            ,{header:'姓名',width:80,dataIndex:'PatName',sortabale:true}
            ,{header:'年龄',width:60,dataIndex:'Age',sortable:true}
			,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
            ,{header:'性别',width:60,dataIndex:'Sex',sortable:true}
            ,{header:'上报人',width:80,dataIndex:'RepUser',sortable:true}
            ,{header:'上报科室',width:150,dataIndex:'RepLoc',sortable:true}
            ,{header:'报告状态',width:100,dataIndex:'RepStatusDesc',sortable:true}
            ,{header:'上报时间',width:120,dataIndex:'RepDateTime',sortable:true}
            //,{header:'退回原因',width:200,dataIndex:'BackReason',sortable:true}
            ,{header:'重复打印原因',width:200,autoHeight: true,dataIndex:'PrintReason',sortable:true}
            ,{
				header: '打印明细',
				width: 100,
				dataIndex: 'RowID',
				renderer : function(v, m, rd, r, c, s){
					var RepordID = rd.get("RowID");
					var txtStartDate=obj.txtStartDate.getRawValue();
					var txtEndDate=obj.txtEndDate.getRawValue();
					return " <a href='#' onclick='PrintReasonSubLookUpHeader(\""+RepordID+"\");'>&nbsp;查看&nbsp; </a>";
				}
			}        
         ]
         ,bbar:new Ext.PagingToolbar({
             pageSize:50
            ,store:obj.gridDeathReportStore
            ,displayMsg:'显示记录：{0}-{1} 合计：{2}'
            ,displayInfo:true
            ,emptyMsg:'没有记录'
         })
    });
	var today = new Date();
	today.setDate(1);
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"DTH");
    obj.cboRepLoc = Common_ComboToLoc("cboRepLoc","科室","","","","cboSSHosp");  //fix by pylian 108558 科室下面不显示急诊科 
	obj.cboRepStatus = Common_ComboToDic("cboRepStatus","报告状态","DTHRunningState");
    obj.txtStartDate = Common_DateFieldToDate("txtStartDate","开始日期");
	obj.txtStartDate.setValue(today);
    obj.txtEndDate = Common_DateFieldToDate("txtEndDate","结束日期");
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
		,text : '查询'
		,width : 50
	});
	obj.btnExport= new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,text : '导出'
		,width : 50
	});
	
	obj.btnExportDtl= new Ext.Button({
		id : 'btnExportDtl'
		,iconCls : 'icon-export'
		,text : '导出详细数据'
		,width : 80
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
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtStartDate]
									},{
										width : 180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtEndDate]
									},{
										width : 210
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboSSHosp]
									},{
										width : 250
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboRepLoc]
									},{
										width : 150
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboRepStatus]
									}
								]
							},{
								layout : 'column',
								items : [
									{
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
										width : 210
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtRegNo]
									},{
										width : 50
									},{
										width : 80
										,layout : 'form'
										,items: [obj.btnFind]
									},{
										width : 20
									},{
										width : 80
										,layout : 'form'
										,items: [obj.btnExport]
									},{
										width : 20
									},{
										width : 110
										,layout : 'form'
										,items: [obj.btnExportDtl]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridDeathReport
						]
					}
				]
			}
		]
	});
	
	obj.gridDeathReportStoreProxy.on('beforeload',function(gridDeathReportStoreProxy,param){
			param.ClassName = 'DHCMed.DTHService.ReportSrv';
			param.QueryName = 'QryReportInfo';
			param.Arg1      = obj.txtStartDate.getRawValue();
			param.Arg2      = obj.txtEndDate.getRawValue();
			param.Arg3      = obj.cboRepLoc.getValue();
			param.Arg4      = obj.cboSSHosp.getValue();
			param.Arg5      = obj.cboRepStatus.getValue();
			param.Arg6      = obj.txtPatName.getValue();
			param.Arg7      = obj.txtMrNo.getValue();
			param.Arg8      = obj.txtRegNo.getValue();
			param.ArgCnt    = 8;
	});
	
    InitDMReportListEvent(obj);
    obj.LoadEvent();
}