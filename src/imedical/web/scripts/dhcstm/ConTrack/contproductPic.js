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
ShowProductImageWindow = function(Store,rowid,type) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc = "http://" + gParam[5];
	var sellist="";
    //alert(ftpsrc);
//	alert(inci);
   // var ftpsrc="http://172.16.100.50/ftpdir/STUPLOAD/"
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
	var bUpdate = new Ext.Toolbar.Button({
		text : '���ͼƬ',
		tooltip : '���ͼƬ',
		iconCls : 'page_goto',
		handler : function() {
			
			addProductImage('product',PicWin.rowid);
		}
	});
	
	
	var bDelete = new Ext.Toolbar.Button({
		text : 'ɾ��ѡ��ͼƬ',
		tooltip : 'ɾ��ѡ��ͼƬ',
		iconCls : 'page_goto',
		handler : function() {
			var arrpicr = picView.getSelectedRecords() // ����
			if ((!arrpicr)||(arrpicr.length==0) ){
				Msg.info("warning", '��ѡ��Ҫɾ����ͼƬ!');
				return;
			}
			var picr = arrpicr[0];
			var row = picr.get("rowid");
			var picsrc = picr.get("picsrc");
			FnDel(row, picsrc,picr);
			
		}
	});
	
	var bSetProductMaster= new Ext.Toolbar.Button({
		text : '����Ϊ��ͼƬ',
		tooltip : '����Ϊ��ͼƬ',
		iconCls : 'page_goto',
		handler : function() {
			var arrpicr = picView.getSelectedRecords() // ����
			if ((!arrpicr)||(arrpicr.length==0) ){
				Msg.info("warning", '��ѡ��Ҫ���õ�ͼƬ!');
				return;
			}
			var picr = arrpicr[0];
			var row = picr.get("rowid");
			var imgtype = picr.get("imgtype");
			if (imgtype=='��ͼƬ')
			{Msg.info('error','�Ѿ�����ͼƬ'); return ;}
			
			setProductMaster(row);
			
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
 	
	
	function addProductImage(type,rowid){				
		var dialog = new Ext.ux.UploadDialog.Dialog({
			width : 600,
			height : 400,
			url: 'dhcstm.contrackaction.csp?actiontype=UploadContImage&contRowid='+rowid+"&conttype=product",   ///ȫ��rowid
			reset_on_hide: false,
			permitted_extensions:['gif','jpeg','jpg','png','bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title:'�ϴ�����ͼƬ',
			base_params : {'type':type},
			//post_var_name: 'file'
			listeners:{
				'uploadcomplete':function(){
					retrieve();
	
				}
				
			}
			})
			
		dialog.show();
		
	
	};
	
	var detailPanel = new Ext.Panel({
		region:'center',
		autoScroll : true,
		tbar : ['->',bUpdate,'-',bDelete,'-',bSetProductMaster,'-',bExit],
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
		Store.load({params:{'IncRowid':PicWin.rowid,'type':PicWin.type}});
	}
	
	function FnDel(rowid,picsrc,picr)
	{	//alert(rowid);
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
		    url:'dhcstm.contrackaction.csp?actiontype=DeleteContProductImage&controwid='+rowid+'&contpicsrc='+picsrc,
		    waitMsg:'ɾ����...',
		    failure: function(result, request) {
		    	 mask.hide();
		        Msg.info("error", "������������!");
		        return false;
		    },
		    success: function(result, request) {
		        var jsonData = Ext.util.JSON.decode( result.responseText );
		         mask.hide();
		        if (jsonData.success=='true') {
		            Msg.info("success", "ɾ���ɹ�!");
			            
					Store.remove(picr);
					picView.refresh();
			 
		            return true;
		  
		        }else{ 
		                Msg.info("error", "ɾ��ʧ��!");
		                return false;
		        }
		    },
		    scope: this
		});
		return true;
     } 	
	function setProductMaster(rowid)
	{
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
		    url:'dhcstm.contrackaction.csp?actiontype=setContProductMaster&controwid='+rowid,
		    waitMsg:'�޸���...',
		    failure: function(result, request) {
		    	 mask.hide();
		        Msg.info("error", "������������!");
		        return false;
		    },
		    success: function(result, request) {
		        var jsonData = Ext.util.JSON.decode( result.responseText );
		         mask.hide();
		        if (jsonData.success=='true') {
		            Msg.info("success",jsonData.message);    
					Store.reload();
					picView.refresh();
		            return true;
		        }else{ 
					Msg.info("error",jsonData.message);
					return false;
		        }
		    },
		    scope: this
		});
		return true;
	
	
	
	}
}