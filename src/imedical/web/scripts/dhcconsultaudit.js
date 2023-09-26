var SearchStart = new Ext.form.DateField(
	                   {
                    xtype: 'datefield',
                    fieldLabel: '开始',
					id:'startdate',
					width:90,
					//format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor : '90%'
                }
	);	
var SearchEnd = new Ext.form.DateField(
	                   {
                    xtype: 'datefield',
                    fieldLabel: '结束',
					id:'enddate',
					width:90,
					//format:'Y-m-d',
					value:new Date(),
                    name: 'date',
					anchor : '90%'
                }
	);
	///这个不用了
var UnAudit = new Ext.form.Radio({
		boxLabel: '未审',
		                xtype: 'radiogroup',
                        name: 'rad',
						id:'UnAudit',
						checked: true,
                        value: '2',
                        width: '100'
	});
var Audit = new Ext.form.Radio({
		
		boxLabel: '已审',
		                xtype: 'radiogroup',
                        name: 'rad',
						id:'Audit',
                        value: '2',
                        width: '100'
	
	});
var comboData = [
        ['W','待审'],
        ['E','审核'],
        ['F','已完成'],
		['R','已拒绝']
    ];
var Searchstore=new Ext.data.SimpleStore({
                fields:['disvalue','distext'],
                data: comboData
            });
//查询条件 
var Searchflag=new Ext.form.ComboBox({		  
			  xtype: "combo",
			         id:"Searchflag",
					 width : 100,
                     fieldLabel: "状态",
                     mode:"local", //直接定义写成local
                     triggerAction: 'all', //加载所有项
                     editable: false,
                     emptyText: "",
                     store: Searchstore,
                     displayField: 'distext',//
					 valueField:'disvalue',
					 anchor : '100%'
                 });
var CTLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var CTLocStore = new Ext.data.Store({
		proxy: CTLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});

var CTLoc = new Ext.form.ComboBox({
		id : 'CTLoc'
		,width : 100
		,store : CTLocStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'CTLocID'
});

CTLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsultNew';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = CTLoc.getRawValue();
			param.Arg2 = 'E';
			param.Arg3 = "";  //cboWard.getValue();
			param.Arg4 = "";  //CTHos.getValue();;
			param.ArgCnt = 4;
	 });
var btnQuery = new Ext.Button({
		id : 'btnQuery'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 60
		,iconCls : 'icon-find'
		,text : '查询'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var gridconsultauditStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var gridconsultauditStore = new Ext.data.Store({
		id: 'gridconsultauditStore',
		proxy: gridconsultauditStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		}, 
		[
		    
			{name: 'PatDep', mapping: 'PatDep'}
			,{name: 'BedCode', mapping: 'BedCode'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'Diag', mapping: 'Diag'}
			,{name: 'Destination', mapping: 'Destination'}
			,{name: 'Destinationtwo', mapping: 'Destinationtwo'}
			
			,{name: 'RequestDep', mapping: 'RequestDep'}
			,{name: 'RequestDoc', mapping: 'RequestDoc'}
			,{name: 'Contyp', mapping: 'Contyp'}
			,{name: 'InOut', mapping: 'InOut'}
			,{name: 'AppDate', mapping: 'AppDate'}
			,{name: 'AppTime', mapping: 'AppTime'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'EpisodeId', mapping: 'EpisodeId'}
			,{name: 'RowID', mapping: 'RowID'}
		])
	});
var consultaudit = new Ext.grid.GridPanel({
		id : 'consultaudit'
		,store : gridconsultauditStore
		,region : 'center'
		,layout: 'fit'
		,buttonAlign : 'center'
		,autoFill : true
		,loadMask : { msg : '正在读取数据,请稍后...'} //一个 Ext.LoadMask 配置，或者为true以便在加载时遮罩grid。 默认为 false .
		//,plugins: obj.expCtrlDetail //一个对象或者一个对象数组，为组件提供特殊的功能。 对一个合法的插件唯一的要求是它含有一个init()方法， 能接收一个Ext.Component型的参数。当组件被创建时，如果有可用的插件，组件将会调用每个插件的init方法，并将自身的引用作为方法参数传递给它。然后，每个插件就可以调用方法或者响应组件上的事件，就像需要的那样提供自己的功能。 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"床号"	,width:60})*/
			new Ext.grid.RowNumberer(),
			{header: '病人科室', width: 100, dataIndex: 'PatDep', sortable: true}
			,{header: '床号', width: 100, dataIndex: 'BedCode', sortable: true}
			,{header: '病人姓名', width: 100, dataIndex: 'PatName', sortable: true}
			,{header: '主诊断', width: 100, dataIndex: 'Diag', sortable: true}
			,{header: '病情摘要', width: 200, dataIndex: 'Destination', sortable: true}
			,{header: '会诊目的', width: 200, dataIndex: 'Destinationtwo', sortable: true}
			,{header: '会诊科室', width: 100, dataIndex: 'RequestDep', sortable: true}
			,{header: '会诊子科室', width: 100, dataIndex: 'RequestItmDep', hidden:true,sortable: true}
			
			,{header: '会诊医生', width: 100, dataIndex: 'RequestDoc', sortable: true}
			,{header: '类别', width: 100, dataIndex: 'Contyp', sortable: true}
			,{header: '院内院外', width: 100, dataIndex: 'InOut', sortable: true}
			,{header: '申请日期', width: 100, dataIndex: 'AppDate', sortable: true}
			,{header: '申请时间', width: 100, dataIndex: 'AppTime', sortable: true}		
			,{header: '状态', width: 100, dataIndex: 'Status', sortable: true}
			,{header: '就诊id', width: 100, dataIndex: 'EpisodeId', sortable: true}
			,{header: 'RowID', width: 100, dataIndex: 'RowID', sortable: true}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : gridconsultauditStore,
			displayInfo: false,
			emptyMsg: '没有记录',
			layout:'column'
		})
	});			
var ConditionPanel = new Ext.form.FormPanel({
	id : 'ConditionPanel',
	buttonAlign : 'center',
	labelAlign : 'center', 
	labelWidth : 40,
	bodyBorder : 'padding:0 0 0 0',
	layout : 'column',
	region : 'north',
	frame : true,
	height : 40,
	items : [
		{buttonAlign : 'center',
		columnWidth : .18,
		layout : 'form',
		items : [SearchStart]
		},
		{buttonAlign : 'center',
		columnWidth : .18,
		layout : 'form',
		items : [SearchEnd]
		},
		{buttonAlign : 'center',
		columnWidth : .15,
		layout : 'form',
		items : [Searchflag]
		}/*,
		{buttonAlign : 'center',
		columnWidth : .15,
		layout : 'form',            //column  
		items : [UnAudit]
		}*/,
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'form',
		items : [btnQuery]
		}
	]
});	
var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
		
			ConditionPanel,
			consultaudit
		]
	});	
Ext.onReady(function(){
new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	});
Ext.getCmp('Searchflag').setValue('W');
Ext.get('btnQuery').on("click",Search_onclick);
//Ext.get('btnAudit').on("click",Audit_onclick);
Search_onclick();
}
)	
//CTLoc 按申请科室查询暂时不考虑
function Search_onclick()
{
var startdate=Ext.getCmp("startdate");  //开始日期
var enddate=Ext.getCmp("enddate");    //结束日期
var startdate=startdate.value;
var enddate=enddate.value;
///var UnAudit=Ext.getCmp("UnAudit").getValue(); //UnAudit.getValue();
var Searchflag=Ext.getCmp("Searchflag").getValue(); 
//alert(Searchflag)
//alert(startdate+"#"+enddate+"#"+UnAudit)

Ext.Ajax.request({
			url:'dhcconsultrequest.csp',
			params:{action:'GetConsultList',startdate:startdate,enddate:enddate,Auditflag:Searchflag} ,
			success: function(result, request) {
				gridconsultauditStore.removeAll();
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.GetConList!='') {
					var ConSultListArr=jsonData.GetConList.split("!");
					for (var i=0;i<ConSultListArr.length;i++) {
						//{name: 'checked', mapping : 'checked'}
						var PatDep = ConSultListArr[i].split("^")[0];
						var BedCode = ConSultListArr[i].split("^")[1];
						var PatName = ConSultListArr[i].split("^")[2];
						var Diag = ConSultListArr[i].split("^")[3];
						var Destination = ConSultListArr[i].split("^")[4];
						var Destinationtwo=ConSultListArr[i].split("^")[5];
						var RequestDep = ConSultListArr[i].split("^")[6];
						var RequestItmDep= ConSultListArr[i].split("^")[7];
						var RequestDoc = ConSultListArr[i].split("^")[8];
						
						var Contyp = ConSultListArr[i].split("^")[9];
						var InOut = ConSultListArr[i].split("^")[10];
						var AppDate = ConSultListArr[i].split("^")[11];
						var AppTime = ConSultListArr[i].split("^")[12];
						var Status = ConSultListArr[i].split("^")[13];
						var EpisodeId = ConSultListArr[i].split("^")[14];
						var RowID = ConSultListArr[i].split("^")[15];
						
						var record = new Object();
			       		record.PatDep = PatDep ;
			       		record.BedCode = BedCode ;
			       		record.PatName = PatName ;
			       		record.Diag = Diag ;
			       		record.Destination = Destination ;
						record.Destinationtwo=Destinationtwo;
						record.RequestDep=RequestDep;
						record.RequestItmDep=RequestItmDep;
						record.RequestDoc=RequestDoc;
			       		record.Contyp = Contyp ;
			       		record.InOut = InOut ;
			       		record.AppDate = AppDate ;
			       		record.AppTime = AppTime ;
			       		record.Status = Status ;
			       		record.EpisodeId = EpisodeId ;
						record.RowID=RowID;
			       		var records = new Ext.data.Record(record);
			       		
						gridconsultauditStore.add(records);
					}
				}
			},
			scope: this
		}) ;
}	
	
var contextmenu =new Ext.menu.Menu({
        id: 'theContextMenu',
        items: [{
            text: '审核',
			id: 'AuditConsult',
            handler:AuditConsult
        },
		{
			text: '会诊完成',
			id: 'EndConsult',
			hidden:true,
			handler:EndConsult
		}
		]
    })
grid=Ext.getCmp("consultaudit");
grid.on("rowcontextmenu", function(grid, rowIndex, e){
        e.preventDefault();
        var row = grid.getSelectionModel().getSelected(); //.selectRow(rowIndex);
		if(!row) return; 
		var auditStatus = row.data.Status;
		var ret = tkMakeServerCall('User.DHCConsultDepItm', 'GetConfig');
		var ifOpenMoreLocAuditExec = ret.split("^")[3];
		if(!((ifOpenMoreLocAuditExec=="Y")&&(auditStatus=="审核"))){
			var EndConsultTool = Ext.getCmp("EndConsult");
			EndConsultTool.hide();// = false;
		}
		contextmenu.doLayout();
        contextmenu.showAt(e.getXY());
    });

	
function AuditConsult() {
	
	grid = Ext.getCmp("consultaudit");
	var linenum = grid.getSelectionModel().lastActive; //获取行号
	var records = gridconsultauditStore.getAt(linenum);
	var obj = grid.store.data.items[linenum].data;
	var EpisodeId = obj.EpisodeId;
	/*var dish = tkMakeServerCall("web.DHCSETIMAGE", "DocDisch", EpisodeId);
	if (dish == 1) {
		alert("已做医疗结算,不能进行会诊审核!");
		return;
	}*/
	var RowID = obj.RowID;
	var lnk = "dhcconsultlistnew.csp?rowid=" + RowID+"&EpisodeId=" + EpisodeId;
	window.open(lnk, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1366,height=768,left=0,top=0')
	//window.close();

}
function EndConsult() {
	var dish = tkMakeServerCall("web.DHCDischargeHistory", "GetDischargeDateTime", EpisodeId);
	if (dish != '^') {
		alert("病人已出院!");
		return;
	}
	var userid = session['LOGON.USERID'];
	var loc = session['LOGON.CTLOCID'];
	var linenum = grid.getSelectionModel().lastActive; //获取行号
	var records = gridconsultauditStore.getAt(linenum)
		var obj = grid.store.data.items[linenum].data
		var RowID = obj.RowID;
	var ret = tkMakeServerCall("web.DHCConsultNew", "ExcuteMoreConsult", RowID, userid, loc);
	if (ret == "0") {
		alert("操作成功")
		Search_onclick()
	} else {
		alert(ret)
		return;
	}
}

////combobox选择时调用查询
Searchflag.on('select', CallSearchclick);	
function CallSearchclick(combo, record, index)
{
Search_onclick()
}










