var fheight = document.body.clientHeight-2;
var fwidth = document.body.clientWidth-2;
var REC = new Array();
var REC1=new Array();

//判断安全组
var secGrpFlag=toMgSecGrp(session['LOGON.GROUPID']);
//alert(secGrpFlag);

var combo = new Ext.form.ComboBox({
	id:'comboward',
 store:new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:[{'name':'WardDesc','mapping':'WardDesc'},{'name':'rw','mapping':'rw'}]
		}),
		baseParams:{className:'web.DHCNurRosterComm',methodName:'GetWardData',type:'RecQuery'}
	}),
	listeners:{ 
			beforeload:function(tstore,e){ 
				tstore.baseParams.parr=secGrpFlag+'^'+session['LOGON.USERCODE'];
				tstore.baseParams.input=Ext.getCmp('comboward').lastQuery;
			},
			focus: {
				fn: function (e) {
				e.expand();
				this.doQuery(this.allQuery, true);
				},
				buffer: 200
			},
			beforequery: function (e) {
				var combo = e.combo;
				var me = this;
				if (!e.forceAll) {
					var input = e.query;
					var regExp = new RegExp("^" + input + ".*", "i");
						combo.store.filterBy(function (record, id) {
						var text = getPinyin(record.data[me.displayField]);
						return regExp.test(text)|regExp.test(record.data[me.displayField]);
					});
					combo.expand();
					combo.select(0, true);
					return false;
				}
		    }
		},
	//tabIndex:'0',
	listWidth:200,width:150,xtype : 'combo',
	displayField : 'WardDesc',valueField : 'rw',hideTrigger : false,queryParam : '',triggerAction : 'all',
	minChars : 1,pageSize : 10,typeAhead : false,typeAheadDelay : 1000,loadingText : 'Searching...'
});
var PerTypeCmb=new Ext.form.ComboBox({
	id:'personType',width:100,triggerAction: 'all',mode: 'local',value:'N',
	store: new Ext.data.ArrayStore({
    fields: ['id','desc'],
    data:[['N','正式'],['W','护理员'],['P','实习'],['S','进修']] //,['T','培训护士']]
	}),
	valueField: 'id',
	displayField: 'desc',
	value:''
});
function BodyLoadHandler()
{
	createGrid();
}
function createGrid()
{
	var gform = Ext.getCmp("gform"); 
	var mainpanel = createPanel();
	gform.add(mainpanel);
	gform.doLayout();
	var mainpanel = Ext.getCmp("mainpanel");
	var tobar = mainpanel.getTopToolbar();
	if(secGrpFlag=="nurhead")
	{
		combo.store.load({params:{start:0,limit:1000},callback:function(){combo.setValue(session['LOGON.CTLOCID']);}});
		combo.disable();
	}
	tobar.addItem("-");
	tobar.addItem("病区",combo);
	tobar.addItem("-");
	var ndate=new Date(),nweek=ndate.format('N');
	tobar.addItem("开始日期",new Ext.form.DateField({id:'stdate',value:ndate.add(Date.DAY,1-nweek)}));
	tobar.addItem("-");
	tobar.addItem("结束日期",new Ext.form.DateField({id:'enddate',value:ndate.add(Date.DAY,7-nweek)}));
	tobar.addItem("-");
	tobar.addItem("人员类型",PerTypeCmb);
	tobar.addItem("-");
	tobar.addButton({id:'btn1',icon:'../images/uiimages/search.png',text:'查询',handler:function(){reloadGrid();LoadData2();}});
	tobar.doLayout();
}
function getWeek(WeekNum)
{
	var WeekStr = "";
	switch(WeekNum)
	{
		case 1:WeekStr = "星期一";break;
		case 2:WeekStr = "星期二";break;
		case 3:WeekStr = "星期三";break;
		case 4:WeekStr = "星期四";break;
		case 5:WeekStr = "星期五";break;
		case 6:WeekStr = "星期六";break;
		case 0:WeekStr = "星期日";break;
	}
	return WeekStr;
}

function createPanel()
{
	var table = createTable(); 
	var panel = new Ext.Panel({
		id:'mainpanel',
		region: 'center',
		margins:'3 3 3 0',
		activeTab: 0,
		x:0,y:0,
		border:false,
		height: fheight,
		width: fwidth,
		defaults:{autoScroll:true},
		tbar:[],
		items:[{
			items:[table]
		}]
	});
	return panel;
}
function reloadGrid()
{
	var mainpanel=Ext.getCmp('mainpanel');
	mainpanel.removeAll();
	var table=createTable();
	mainpanel.add(table);
	mainpanel.doLayout();
}
function createTable()
{
	var colModelStr = new Array();
	var colData = new Array();
	colModelStr.push({header: '班次', width: 80, align:'center', sortable: false,dataIndex: 'PostDesc'});
	colData.push({'name':'PostDesc','mapping':'PostDesc'});
	var ndate=new Date();
	var stdate=Ext.getCmp('stdate');
	if(stdate!=null)	stdate=stdate.getValue();
	else stdate=ndate.add(Date.DAY,1-ndate.format('N'));
	var enddate=Ext.getCmp('enddate');
	if(enddate!=null) enddate=enddate.getValue();
	else enddate=ndate.add(Date.DAY,7-ndate.format('N'));
	for(AdmDate=stdate;AdmDate.between(stdate,enddate);AdmDate=AdmDate.add(Date.DAY,1)){
		//colModelStr .push({header:(AdmDate.format('Y-m-d')+'<br>'+getWeek(AdmDate.getDay())), align:'center', width: 80, sortable: false,dataIndex: 'Date'+AdmDate.format('Y-m-d')});
		//colData.push({'name':'Date'+AdmDate.format('Y-m-d'),'mapping':'Date'+AdmDate.format('Y-m-d')});
		var flagNum = tkMakeServerCall('websys.Conversions','DateFormat');
//		//debugger
		if(flagNum==4){
			AdmDate1 = AdmDate.format('d/m/Y');
		}else if(flagNum==3){
			AdmDate1 = AdmDate.format('Y-m-d');
		}
	
		colModelStr.push({header:(AdmDate1+'<br>'+getWeek(AdmDate.getDay())), align:'center', width: 100, sortable: false,dataIndex: 'Date'+AdmDate1});
		colData.push({'name':'Date'+AdmDate1,'mapping':'Date'+AdmDate1});
	}
	colModelStr.push({header: '人次', width: 80,align:'center', sortable: false,dataIndex: 'TotalNum'});
	colData.push({'name':'TotalNum','mapping':'TotalNum'});
	var colModel = new Ext.grid.ColumnModel(colModelStr);
	var store = new Ext.data.Store({
		proxy:new Ext.data.HttpProxy({url:"../csp/dhc.nurse.ext.common.getdata.csp"}),
		reader:new Ext.data.JsonReader({root:'rows',totalProperty:'results',
			fields:colData
		}),
		baseParams:{className:'DHCMGNUR.MgNurArrangeJob',methodName:'FindPostDataByPost',type:'RecQuery'},
		listeners:{
			beforeload:function(tstore,e){
				var WardId = combo.getValue();
				var stdate = Ext.getCmp('stdate').getValue().format('Y-m-d');
				var enddate = Ext.getCmp('enddate').getValue().format('Y-m-d');
				var PersonType=Ext.getCmp('personType').getValue();
				var parr = WardId+"^"+stdate+"^"+enddate+"^"+PersonType; 
				tstore.baseParams.parr=parr;
			}
		}
	});
	var table = new Ext.grid.GridPanel({
		renderTo:document.body,
		id:'mygrid',
		x:0,y:0,
		height: fheight-20,
		width: fwidth,
		store: store,
		cm :colModel,
		bbar: new Ext.PagingToolbar({ 
        pageSize: 20, 
        store: store,
        //hidden:true,
        displayInfo: true, 
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条', 
        emptyMsg: "没有记录" 
    })
	});
	return table;
}

function LoadData()
{
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:20}});
}
function LoadData2()
{
	var wardid=combo.getValue();
	if(wardid=="")
 
	{
		Ext.Msg.alert('提示','请选择病区！');
		return;
	}
	var mygrid=Ext.getCmp('mygrid');
	mygrid.store.load({params:{start:0,limit:20}});
}