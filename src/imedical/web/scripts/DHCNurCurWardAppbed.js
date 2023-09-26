
var cboWardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var cboWardStore = new Ext.data.Store({
		proxy: cboWardStoreProxy,
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
var cboWard = new Ext.form.ComboBox({
		id : 'cboWard'
		,width : 100
		,minChars : 1 //在自动完成和typeAhead 激活之前，用户必须输入的最少字符数
		,selectOnFocus : true //true 将会在获得焦点时理解选中表单项中所有存在的文本。 仅当editable = true 时应用(默认为false)。 
		,forceSelection : true //true 将会限定选择的值是列表中的值之一， false将会允许用户向表单项中设置任意值 (默认为false) 
		,store : cboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '病区'
		,editable : true //false将阻止用户直接向表单项中输入文本，表单项将仅仅响应 在触发按钮上进行鼠标点击然后设置值。(默认为true)。 
		,triggerAction : 'all'  //当触发器被点击时需要执行的操作。
		,anchor : '100%'
		,valueField : 'CTLocID'
	});



var btnQuery = new Ext.Button({
		id : 'btnQuery'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 90
		,iconCls : 'icon-find'
		,text : '查询'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var btnAudit = new Ext.Button({
		id : 'btnAudit'
		,fieldLabel : ''
		//,anchor : '55%'
		//,hideLabel:true
		//,xtype: 'tbfill' 
		//,xtype : 'tbspacer'
		,width : 90
		,text : '审核'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
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
var CurWardAppBedStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
var CurWardAppBedStore = new Ext.data.Store({
		id: 'CurWardAppBedStore',
		proxy: CurWardAppBedStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'BedId'
		}, 
		[
		    
			{name: 'BedId', mapping: 'BedId'}
			,{name: 'BedCode', mapping: 'BedCode'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PatSex', mapping: 'PatSex'}
			,{name: 'PatAge', mapping: 'PatAge'}
			,{name: 'ApointDate', mapping: 'ApointDate'}
			,{name: 'DiagnosDesc', mapping: 'DiagnosDesc'}
			,{name: 'BedStatus', mapping: 'BedStatus'}
			,{name: 'BedBill', mapping: 'BedBill'}
			,{name: 'WardID', mapping: 'WardID'}
		])
	});
	 var sm = new Ext.grid.CheckboxSelectionModel();
var CurWardAppBed = new Ext.grid.GridPanel({
		id : 'CurWardAppBed'
		,store : CurWardAppBedStore
		,region : 'center'
		,layout: 'fit'
		,buttonAlign : 'center'
		,autoFill : true
		,loadMask : { msg : '正在读取数据,请稍后...'} //一个 Ext.LoadMask 配置，或者为true以便在加载时遮罩grid。 默认为 false .
		//,plugins: obj.expCtrlDetail //一个对象或者一个对象数组，为组件提供特殊的功能。 对一个合法的插件唯一的要求是它含有一个init()方法， 能接收一个Ext.Component型的参数。当组件被创建时，如果有可用的插件，组件将会调用每个插件的init方法，并将自身的引用作为方法参数传递给它。然后，每个插件就可以调用方法或者响应组件上的事件，就像需要的那样提供自己的功能。 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"床号"	,width:60})*/
			new Ext.grid.RowNumberer(),
			{header: '床位id', width: 100, dataIndex: 'BedId', sortable: true ,hidden:true}
			,{header: '床号', width: 100, dataIndex: 'BedCode', sortable: true}
			,{header: '患者姓名', width: 100, dataIndex: 'PatName', sortable: true}
			,{header: '性别', width: 100, dataIndex: 'PatSex', sortable: true}
			,{header: '年龄', width: 100, dataIndex: 'PatAge', sortable: true}
			,{header: '预约日期', width: 100, dataIndex: 'ApointDate', sortable: true}
			,{header: '诊断', width: 250, dataIndex: 'DiagnosDesc', sortable: true,hidden:true}
			,{header: '床位状态', width: 150, dataIndex: 'BedStatus', sortable: true}
			,{header: '床位费用', width: 100, dataIndex: 'BedBill', sortable: true}
			,{header: '病区id', width: 100, dataIndex: 'WardID', sortable: true ,hidden:true}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : CurWardAppBedStore,
			displayInfo: false,
			emptyMsg: '没有记录',
			layout:'column'
		})
	});
var ConditionPanel = new Ext.form.FormPanel({
	id : 'ConditionPanel',
	buttonAlign : 'center',
	labelAlign : 'center', 
	labelWidth : 60,
	bodyBorder : 'padding:0 0 0 0',
	layout : 'column',
	region : 'north',
	frame : true,
	height : 40,
	items : [
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'form',
		items : [cboWard]
		},
		{buttonAlign : 'center',
		columnWidth : .15,
		layout : 'form',
		items : [Audit]
		},
		{buttonAlign : 'center',
		columnWidth : .1,
		layout : 'column',
		items : [UnAudit]
		},
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'form',
		items : [btnQuery]
		},
		{buttonAlign : 'center',
		columnWidth : .2,
		layout : 'form',
		items : [btnAudit]
		}
	]
});
var pnScreen = new Ext.Panel({
		id : 'pnScreen'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'border'
		,items:[
		
			CurWardAppBed
		]
	});

cboWardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'Nur.DHCBedManager';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = cboWard.getRawValue();
			param.Arg2 = 'W';
			param.Arg3 = "";
			param.Arg4 = "";
			param.ArgCnt = 4;
	});
function Search_onclick()
{
       var CTWardID=session['LOGON.CTLOCID'];
		Ext.Ajax.request({
			url:'DHCNurBedManagerequest.csp',
			params:{action:'GetAppBed',CTWardID:CTWardID} ,
			success: function(result, request) {
				CurWardAppBedStore.removeAll();
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.AppBedList!='') {
					var AppBedListArr=jsonData.AppBedList.split("!");
					//alert(AppBedListArr)
					for (var i=0;i<AppBedListArr.length;i++) {
						//{name: 'checked', mapping : 'checked'}
						var BedId = AppBedListArr[i].split("^")[0];
						var BedCode = AppBedListArr[i].split("^")[1];
						var PatName=AppBedListArr[i].split("^")[2];
						var PatSex=AppBedListArr[i].split("^")[3];
						var PatAge=AppBedListArr[i].split("^")[4];
						var ApointDate=AppBedListArr[i].split("^")[5];
						var DiagnosDesc=AppBedListArr[i].split("^")[6];
						var BedStatus=AppBedListArr[i].split("^")[7];
						var BedBill=AppBedListArr[i].split("^")[8];
						var WardID = AppBedListArr[i].split("^")[9];
						
						var record = new Object();
			       		
			       		record.BedId = BedId ;
						record.BedCode=BedCode;
						record.PatName=PatName;
						record.PatSex=PatSex;
						record.PatAge=PatAge;
						record.ApointDate=ApointDate;
						record.DiagnosDesc=DiagnosDesc;
						record.BedStatus=BedStatus;
						record.BedBill=BedBill;
			       		record.WardID = WardID ;
			       		
			       		var records = new Ext.data.Record(record);
						CurWardAppBedStore.add(records);
					}
				}
			},
			scope: this
		}) ;

}

	
Ext.onReady(function(){
new Ext.Viewport({
		id : 'viewScreen'
		,frame : true
		,layout : 'fit'
		,items:[
			pnScreen
			
		]
	});
Search_onclick();
}
)
/*
var contextmenu =new Ext.menu.Menu({
        id: 'theContextMenu',
        items: [
		
		{
            text: '转科换床申请',
			id:'ChangeBedApp',
            handler:ChangeBedApp
        }
		]
    })
	*/
	//grid=Ext.getCmp("gridResult");
CurWardAppBed.on("rowcontextmenu", function(grid1, rowIndex, e){
        e.preventDefault();
        grid1.getSelectionModel().selectRow(rowIndex);
        contextmenu.showAt(e.getXY());
    });

function ChangeBedApp()
{
var linenum=CurWardAppBed.getSelectionModel().lastActive; //获取行号
var objresult=CurWardAppBed.store.data.items[linenum].data;
var win = new Ext.Window({	
            title: '转科/换床申请', 
			layout: 'form',					
			width: 350, 
			height: 300, 
			modal: true,
			labelAlign:'right',	
			items: [
			{
			   xtype:'field', 
			   fieldLabel:'床号', 
			   width:160, 
			   value: objresult.BedCode,
			   disabled:true
			   	},
		    {
			   xtype:'field', 
			   fieldLabel:'患者', 
			   width:160, 
			   value: objresult.PatName,
			   disabled:true
			   	},
			{
							xtype : 'button',
							id : 'ChangeApp',
							buttonAlign: 'center',
							text : '确认',
							height:30,width:80,
							style: 'margin:50 121',  ////gg 这种方式调位置,没想到其他法子 
							handler : function(t,e){
						var ret=tkMakeServerCall("User.DHCBedChangeApp","Save","",objresult.EpisodeID,"0");
						//alert(setdate.value)
						if (ret=="0") 
						{
						alert("申请成功")
						Search_onclick();
						}
						else
						{
						alert(ret)
						return;
						}
                        win.close();
						return;
							}
				}
			]
			})
	win.show();
}

function Audit_onclick()
{
var linenum=CurWardAppBed.getSelectionModel().lastActive; //获取行号
var objresult=CurWardAppBed.store.data.items[linenum].data;
var ret=tkMakeServerCall("User.DHCBedChangeApp","Audit",objresult.Appid);
if (ret=="0")
{
alert("审核成功")
Search_onclick()
}
}



