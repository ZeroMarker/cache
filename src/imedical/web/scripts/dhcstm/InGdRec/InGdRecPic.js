/**
 * ����: ͼƬչʾ����
 * 
 * ����: ��д�ߣ�xuchao ��д����: 2014.5.22
 * 
 * @param {}
 *            store �а������ֶ� rowid ɾ��ʱ��Ӧ��rowid picsrc ͼƬ��·��
 * 
 * @param {}
 *            Fndelete ���ý��淽�������ɾ�����ݿ���ͼƬ��Ϣ
 */
var cus = null;
var PicWin=null;
var gParam = [];
var selectedPicType='';
var selectedPicTypeDesc='';
function GetParam() {
	var userId = session['LOGON.USERID'];
	var groupId = session['LOGON.GROUPID'];
	var locId = session['LOGON.CTLOCID'];
	var url = 'dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId=' + groupId
			+ '&LocId=' + locId + '&UserId=' + userId;
	var response = ExecuteDBSynAccess(url);
	var jsonData = Ext.util.JSON.decode(response);
	if (jsonData.success == 'true') {
		var info = jsonData.info;
		if (info != null || info != '') {
			gParam = info.split('^');
		}
	}
	return;
}

if (gParam.length < 1) {
	GetParam(); // ��ʼ����������
}
////flag �ж��Ƿ����store��formpanel
ShowInGdRecProductImageWindow = function(Store,rowid,type) {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc =  gParam[5];
	var sellist="";
    //alert(ftpsrc);
//	alert(inci);
    //var ftpsrc="http://172.16.100.50/ftpdir/STUPLOAD/"
	var picTpl = new Ext.XTemplate(
			'<tpl for=".">',
			'<div style="padding:5px; height:260px; width:260px; float:left;" class="select_pic" >',
			'<img  class="pic" src="'
					+ ftpsrc
					+ '{picsrc}"style="height:250px; width:250px;"position: relative;>',
			'<p>{imgtype}</p>',		
			'</div>', '</tpl>');

	var picView = new Ext.DataView({
		store : Store,
		tpl : picTpl,
		frame : true,
		singleSelect : true,
		trackOver : true,
		selectedClass : 'selected-pic',
		overClass : 'over-pic',
		itemSelector : 'div.select_pic',
		emptyText : 'û��ͼƬ',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
				//alert(ftpsrc + src);
				Ext.get("custom").dom.src = ftpsrc + src;
				// //��ȡͼƬ��ʵ�ʴ�С
				var image = new Image();
				image.src = ftpsrc + src;
				document.body.appendChild(image); //����ͼƬ
				if (!cus) {
					cus = new Ext.Resizable("custom", {
						wrap : true,
						pinned : true,
						preserveRatio : true,
						dynamic : true,
						handles : 'all', // shorthand for 'n
						draggable : true
						});
					}
                    var customEl = cus.getEl();
					customEl.on('dblclick', function() {
						cus.resizeTo(1, 1)
						flag=0
						PicWin.show()
					});
					var height = 600 // /����Ĭ�ϸ߶�
					var width = image.width / (image.height / height) // /���ձ�������
																		// ��ֹ����
					cus.resizeTo(width, height);
					PicWin.hide()
			}

		}

	});
		
 	var bExit= new Ext.Toolbar.Button({
 		text : '�˳�',
 		tooltip:'�˳�',
 		iconCls : 'page_goto',
 		handler:function()
 		{
 			PicWin.hide();
 		}
 	});
 	
	
	var detailPanel = new Ext.Panel({
		region:'center',
		autoScroll : true,
		items : picView
	});
		
	if(!PicWin){ PicWin = new Ext.Window({
		title : 'ͼƬ��Ϣ',
		width : 820,
		height : 600,
		closeAction:'hide',
		layout : 'border',
		 listeners:{
	   	      'show':function(){
	   	      	  retrieve();
	   		 }
		 },
		items : [detailPanel],
		rowid:'',
		type:''
	});
	}
	PicWin.rowid=rowid;
	PicWin.type=type;
	PicWin.show();
	function retrieve()
	{
		Store.removeAll();
		Store.load({params:{'InRowid':PicWin.rowid,'type':PicWin.type}});
	}
	
	 	
}