
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
		,minChars : 1 //���Զ���ɺ�typeAhead ����֮ǰ���û���������������ַ���
		,selectOnFocus : true //true �����ڻ�ý���ʱ���ѡ�б��������д��ڵ��ı��� ����editable = true ʱӦ��(Ĭ��Ϊfalse)�� 
		,forceSelection : true //true �����޶�ѡ���ֵ���б��е�ֵ֮һ�� false���������û����������������ֵ (Ĭ��Ϊfalse) 
		,store : cboWardStore
		,displayField : 'CTLocDesc'
		,fieldLabel : '����'
		,editable : true //false����ֹ�û�ֱ��������������ı������������Ӧ �ڴ�����ť�Ͻ��������Ȼ������ֵ��(Ĭ��Ϊtrue)�� 
		,triggerAction : 'all'  //�������������ʱ��Ҫִ�еĲ�����
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
		,text : '��ѯ'
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
		,text : '���'
		,margins : {top:0, right:0, bottom:0, left:100}

	});
var UnAudit = new Ext.form.Radio({
		boxLabel: 'δ��',
		                xtype: 'radiogroup',
                        name: 'rad',
						id:'UnAudit',
						checked: true,
                        value: '2',
                        width: '100'
	});
var Audit = new Ext.form.Radio({
		
		boxLabel: '����',
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
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'} //һ�� Ext.LoadMask ���ã�����Ϊtrue�Ա��ڼ���ʱ����grid�� Ĭ��Ϊ false .
		//,plugins: obj.expCtrlDetail //һ���������һ���������飬Ϊ����ṩ����Ĺ��ܡ� ��һ���Ϸ��Ĳ��Ψһ��Ҫ����������һ��init()������ �ܽ���һ��Ext.Component�͵Ĳ����������������ʱ������п��õĲ��������������ÿ�������init���������������������Ϊ�����������ݸ�����Ȼ��ÿ������Ϳ��Ե��÷���������Ӧ����ϵ��¼���������Ҫ�������ṩ�Լ��Ĺ��ܡ� 
		,columns: [
			/*new Ext.grid.RowNumberer({header:"����"	,width:60})*/
			new Ext.grid.RowNumberer(),
			{header: '��λid', width: 100, dataIndex: 'BedId', sortable: true ,hidden:true}
			,{header: '����', width: 100, dataIndex: 'BedCode', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'PatName', sortable: true}
			,{header: '�Ա�', width: 100, dataIndex: 'PatSex', sortable: true}
			,{header: '����', width: 100, dataIndex: 'PatAge', sortable: true}
			,{header: 'ԤԼ����', width: 100, dataIndex: 'ApointDate', sortable: true}
			,{header: '���', width: 250, dataIndex: 'DiagnosDesc', sortable: true,hidden:true}
			,{header: '��λ״̬', width: 150, dataIndex: 'BedStatus', sortable: true}
			,{header: '��λ����', width: 100, dataIndex: 'BedBill', sortable: true}
			,{header: '����id', width: 100, dataIndex: 'WardID', sortable: true ,hidden:true}
			
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 1000,
			store : CurWardAppBedStore,
			displayInfo: false,
			emptyMsg: 'û�м�¼',
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
            text: 'ת�ƻ�������',
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
var linenum=CurWardAppBed.getSelectionModel().lastActive; //��ȡ�к�
var objresult=CurWardAppBed.store.data.items[linenum].data;
var win = new Ext.Window({	
            title: 'ת��/��������', 
			layout: 'form',					
			width: 350, 
			height: 300, 
			modal: true,
			labelAlign:'right',	
			items: [
			{
			   xtype:'field', 
			   fieldLabel:'����', 
			   width:160, 
			   value: objresult.BedCode,
			   disabled:true
			   	},
		    {
			   xtype:'field', 
			   fieldLabel:'����', 
			   width:160, 
			   value: objresult.PatName,
			   disabled:true
			   	},
			{
							xtype : 'button',
							id : 'ChangeApp',
							buttonAlign: 'center',
							text : 'ȷ��',
							height:30,width:80,
							style: 'margin:50 121',  ////gg ���ַ�ʽ��λ��,û�뵽�������� 
							handler : function(t,e){
						var ret=tkMakeServerCall("User.DHCBedChangeApp","Save","",objresult.EpisodeID,"0");
						//alert(setdate.value)
						if (ret=="0") 
						{
						alert("����ɹ�")
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
var linenum=CurWardAppBed.getSelectionModel().lastActive; //��ȡ�к�
var objresult=CurWardAppBed.store.data.items[linenum].data;
var ret=tkMakeServerCall("User.DHCBedChangeApp","Audit",objresult.Appid);
if (ret=="0")
{
alert("��˳ɹ�")
Search_onclick()
}
}



