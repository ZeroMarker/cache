///����:		��ʾ����������
///����:		��ʾ����������
///��д��:	�쳬
///��д����:	2014-11-14

/*��������������ԣ�
*/
var userId = session['LOGON.USERID'];
var groupId=session['LOGON.GROUPID'];
var locId=session['LOGON.CTLOCID'];
var tipwinParam=[];
///��ȡ���õķ�����
function GetTipParam(){
	var info=tkMakeServerCall("web.DHCSTM.Common.TipsWin","GetParamProp",groupId,locId,userId);
	tipwinParam=info.split('^');
	return;
}

if(tipwinParam.length<1){
	GetTipParam();  //��ʼ����������
}
/** ����TabPanel�ĺ��� */
	var Tipaddtab = function(node){
			var tabs=Ext.getCmp('main-tabs');
			var tabId = "tab_"+node.NodeId;
			var iframeId = "iframe_"+node.NodeId;
			var obj = Ext.getCmp(tabId);
			if (!obj){ //�ж�tab�Ƿ��Ѵ�
				var url = node.NodeUrl;   //��Ҫ��href  ���Զ���ת
				obj=tabs.add({
					id:tabId,
					title:node.NodeCaption,
					tabTip:node.NodeCaption,
					html:"<iframe name='"+iframeId+"' frameborder='0' scrolling='auto' height='100%' width='100%' src='"+url+"'></iframe>",
					closable:true,
					listeners : { 'beforeclose': function() {
						var ifclose=false;
						var iframeid = "iframe_"+node.NodeId;
						var viewport = window.frames[iframeid].Ext.getCmp("mainPanel");
						if(viewport){
							var grid = viewport.findByType('grid')[0];
							if(grid){
								var gridEdit = isDataChanged("",grid);
								if(gridEdit){
									Ext.MessageBox.show({
										title : "ȷ�Ϲر�",
										msg :"ȷ�Ϲرո�ҳ�棿",
										buttons : Ext.Msg.YESNO,
										icon : Ext.Msg.WARNIN,
										fn : function(btn) {
											if (btn == 'yes') {
												tabs.remove(Ext.getCmp(tabId));
												ifclose = true;
												return true;
											}
										}
									});
									return ifclose;
								}else{
									return true;
								}
							}else{
								return true;
							}
						}else{
							return true;
						}
					}}
				});
			}
			obj.show();	//��ʾtabҳ
		};

function TipAddPanel(NodeId){
	if(NodeId>0){
		var info=tkMakeServerCall("web.DHCSTM.Common.TipsWin","GetMenuNodeById",NodeId);
		var obj = Ext.util.JSON.decode(info)
		Tipaddtab(obj)
	}
}
//ʹ��ͷ�˵���,ֱ�Ӵ򿪽���
function TipOpenUrl(NodeUrl){
	location.href=NodeUrl;
}

function VendorPanel(VenId){
	CreateVendorPanelWin(VenId);
}
function ManfPanel(ManfId){
	CreateManfPanelWin(ManfId);
}

//����Ƶ������,�Զ���ͣ
function MouseOver(){
	var Task = Ext.getCmp('tipswin').task;
	if(!Ext.isEmpty(Task)){
		Task.cancel();
	}
}
var Tpl = new Ext.XTemplate(
	'<div style=font-size:15px;color:red;>',
	'��������:',
	'<tpl for=".">',
	'<p>',
	'<a href="javascript:void(0)" onclick="TipAddPanel({NodeId})"onmouseover="MouseOver()">&nbsp;&nbsp;&nbsp;&nbsp;{#}��{App}{Info}</a>',
	//'<a href="javascript:void(0)" onclick="TipOpenUrl(\'{NodeUrl}\')"onmouseover="MouseOver()">&nbsp;&nbsp;&nbsp;&nbsp;{#}��{App}{Info}</a>',
	'</p>',
	'</tpl>',
	'</div>'
);
var Tpl2 = new Ext.XTemplate(
	'<div style=font-size:15px;color:red;>',
	'��Ӧ��Ч������:',
	'<tpl for=".">',
	'<p>',
	'<a href="javascript:void(0)" onclick="VendorPanel({Id}) "onmouseover="MouseOver()">&nbsp;&nbsp;&nbsp;&nbsp;{#}��{Name}{Info}<p>{Detail}</p></a>',
	'</p>',
	'</tpl>',
	'</div>'
);
var Tpl3 = new Ext.XTemplate(
	'<div style=font-size:15px;color:red;>',
	'����Ч������:',
	'<tpl for=".">',
	'<p>',
	'<a href="javascript:void(0)" onclick="ManfPanel({Id})" onmouseover="MouseOver()">&nbsp;&nbsp;&nbsp;&nbsp;{#}��{Name}{Info}<p>{Detail}</p></a>',
	'</p>',
	'</tpl>',
	'</div>'
);
var TplInci = new Ext.XTemplate(
	'<div style=font-size:15px;color:red;>',
	'ע��֤��������:',
	'<tpl for=".">',
	'<p style=font-size:15px;color:blue;>',
	//'<a href="javascript:void(0)" onmouseover="MouseOver()">&nbsp;&nbsp;&nbsp;&nbsp;{#}��{Name}{Info}<p>{Detail}</p></a>',
	'<span onmouseover="MouseOver()">&nbsp;&nbsp;&nbsp;&nbsp;{#}��{Name}{Info}<p>{Detail}</p></span>',
	//'&nbsp;&nbsp;&nbsp;&nbsp;{#}��{Name}{Info}',
	'</p>',
	'</tpl>',
	'</div>'
);
var tipswin=new Ext.ux.TipsWindow({
			id:'tipswin',
			width: 300,
			height: 200,
			autoScroll:true,
			title: "��������ʾ",
			html:"���޴���������",
			//�Զ��ر�ʱ�� ����
			autoHide:tipwinParam[2]
		});
var task = {
	run: function(){
		var htmlstr=''
		Ext.Ajax.request({
			url : 'dhcstm.tipswinaction.csp?actiontype=GetTips&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText)
					var html="",html1="",html2="",html3="";
					var htmlInci="";
					if(!Ext.isEmpty(jsonData.doc)){
						html1=Tpl.applyTemplate(jsonData.doc);
					}
					if(!Ext.isEmpty(jsonData.vexp)){
						html2=Tpl2.applyTemplate(jsonData.vexp);
					}
					if(!Ext.isEmpty(jsonData.mexp)){
						html3=Tpl3.applyTemplate(jsonData.mexp);
					}
					if(!Ext.isEmpty(jsonData.incicert)){
						htmlInci=TplInci.applyTemplate(jsonData.incicert);
					}
					html=html1+html2+html3+htmlInci;
					if(html!=""){
						tipswin.html=html;
						tipswin.show();
					}
			},
			scope : this
		});
	},
	interval: 1000*60*tipwinParam[0], //ȡ���õķ�����ֵ
	repeat:Number(tipwinParam[1])             //�ظ�����
}
Ext.TaskMgr.start(task);

function CreateVendorPanelWin(Venderid){
	var APCVendorGridUrl = 'dhcstm.tipswinaction.csp';
	if (CommParObj.NewQuality=="Y")
	{var APCVendorGridProxy= new Ext.data.HttpProxy({url:APCVendorGridUrl+'?actiontype=GetVenderAptnessNew&VenderDr='+Venderid,method:'POST'});}
	else
	{var APCVendorGridProxy= new Ext.data.HttpProxy({url:APCVendorGridUrl+'?actiontype=GetVenderAptness&VenderDr='+Venderid,method:'POST'});}
	var APCVendorGridDs = new Ext.data.Store({
		proxy:APCVendorGridProxy,
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results'
		}, [
			{name:'rowid'},  //���
			{name:'ColName'}, //��������
			{name:'NameInfo'},   //����
			{name:'NameDate'},	 //Ч��
			{name:'NameExpDate'}    //ʣ������
		]),
		remoteSort:false
	});

	var APCVendorGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
			header:"��������",
			dataIndex:'ColName',
			width:160,
			align:'left',
			sortable:true
		},{
			header:"����",
			dataIndex:'NameInfo',
			width:180,
			align:'left',
			sortable:true
		},{
			header:"��ֹЧ��",
			dataIndex:'NameDate',
			width:80,
			align:'left',
			sortable:true
		},{
			header:"��������",
			dataIndex:'NameExpDate',
			width:80,
			align:'left',
			sortable:true
		}
	]);
	var APCVendorGridGrid= new Ext.grid.EditorGridPanel({
		store:APCVendorGridDs,
		cm:APCVendorGridCm,
		trackMouseOver:true,
		region:'center',
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask:true,
		viewConfig:{
			getRowClass:function(record,rowIndex,rowParams,store){
				var ExpDate=record.get("NameExpDate");
				var QualificationDate=tkMakeServerCall("web.DHCSTM.Common.TipsWin","GetQualificationDate",groupId,locId,userId);
				if((ExpDate!="")&&(QualificationDate!="")){
					var ExpDate=parseInt(ExpDate)
					if(QualificationDate>ExpDate){
						return 'my_row_Yellow';
					}
				}
			}
		}
	});
	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	cancelHandler = function(){
		win.close();
	};
	cancelButton.addListener('click',cancelHandler,false);
	var win = new Ext.Window({
		title:'����Ч����Ϣ',
		width:580,
		height:360,
		layout:'fit',
		plain:true,
		buttonAlign:'center',
		items:APCVendorGridGrid,
		buttons:[cancelButton]
	});
	win.show();
	APCVendorGridDs.load();
}

function CreateManfPanelWin(ManfId){
	var ManfGridUrl = 'dhcstm.tipswinaction.csp';
	if (CommParObj.NewQuality=="Y")
	{var ManfGridProxy= new Ext.data.HttpProxy({url:ManfGridUrl+'?actiontype=GetManfAptnessNew&ManfId='+ManfId,method:'POST'});}
	else
	{var ManfGridProxy= new Ext.data.HttpProxy({url:ManfGridUrl+'?actiontype=GetManfAptness&ManfId='+ManfId,method:'POST'});}
	var ManfGridDs = new Ext.data.Store({
		proxy:ManfGridProxy,
		reader:new Ext.data.JsonReader({
			root:'rows',
			totalProperty:'results'
		}, [
			{name:'rowid'},  //���
			{name:'ColName'}, //��������
			{name:'NameInfo'},   //����
			{name:'NameDate'},	 //Ч��
			{name:'NameExpDate'}    //ʣ������
		]),
		remoteSort:false
	});

	var ManfGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
			header:"��������",
			dataIndex:'ColName',
			width:160,
			align:'left',
			sortable:true
		},{
			header:"����",
			dataIndex:'NameInfo',
			width:180,
			align:'left',
			sortable:true
		},{
			header:"��ֹЧ��",
			dataIndex:'NameDate',
			width:80,
			align:'left',
			sortable:true
		},{
			header:"��������",
			dataIndex:'NameExpDate',
			width:80,
			align:'left',
			sortable:true
		}
	]);
	var ManfGrid= new Ext.grid.GridPanel({
		store:ManfGridDs,
		cm:ManfGridCm,
		trackMouseOver:true,
		region:'center',
		sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
		loadMask:true,
		viewConfig:{
			getRowClass:function(record,rowIndex,rowParams,store){
				var ExpDate=record.get("NameExpDate");
				var QualificationDate=tkMakeServerCall("web.DHCSTM.Common.TipsWin","GetQualificationDate",groupId,locId,userId);
				if((ExpDate!="")&&(QualificationDate!="")){
					var ExpDate=parseInt(ExpDate)
					if(QualificationDate>ExpDate){
						return 'my_row_Yellow';
					}
				}
			}
		}
	});
	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	cancelHandler = function(){
		win.close();
	};
	cancelButton.addListener('click',cancelHandler,false);
	var win = new Ext.Window({
		title:'����Ч����Ϣ',
		width:580,
		height:360,
		layout:'fit',
		plain:true,
		buttonAlign:'center',
		items:ManfGrid,
		buttons:[cancelButton]
	});
	win.show();
	ManfGridDs.load();
}