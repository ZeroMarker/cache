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

var DisplayAllTypes=false;

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

var sellist="";
////flag �ж��Ƿ����store��formpanel
ShowPicWindow = function(Store,sa, FnDelete) {
	// alert(sa);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc = "http://" + gParam[5];

	Store.on('load',function(){
			var cnt=Store.getCount();
			if (cnt==0) 
			{
				var x=document.getElementById('pic') ;
				x.src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";	
			}
			else
			{
				picView.select(0);
				
			}	
		});	
//	alert(sellist);
	if (PicWin)
	{
		PicWin.sa=sa;
		PicWin.show();
		return;
	}
					
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div style="padding:5px; height:130px; width:100px; float:left;" class="select_pic" >',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:100px; width:100px;"position: relative;>',
		'<p>{type}({vendesc})</p>',		
		'</div>', '</tpl>');

	var picTpl2 = new Ext.XTemplate(
		'<tpl for=".">',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:150px; width:160px;"position: relative;>',
		'<p>{type}({vendesc})</p>',		
		'</tpl>');		
	
	
	var picView = new Ext.DataView({
		store : Store,
		tpl : picTpl,
		frame : true,
//				multiSelect:true,
		singleSelect : true,
		autoScroll:true,
		trackOver : true,
		selectedClass : 'selected-pic',
		overClass : 'over-pic',
		itemSelector : 'div.select_pic',
		emptyText : '��ѡ��Ҫ��ʾ������ͼƬ',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
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
					cus.resizeTo(1, 1);
					flag=0;
					PicWin.show();
				});
				var height = 600 ;// /����Ĭ�ϸ߶�
				var width = image.width / (image.height / height)  ;// /���ձ�������
																	// ��ֹ����
				cus.resizeTo(width, height);
				PicWin.hide();
			},
			'selectionchange':function(v,arrpicr)
			{
				var arrpicr = v.getSelectedRecords(); // ����
				if (arrpicr.length<1) return;
				var picr = arrpicr[0];
				// var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");				
				var x=document.getElementById('pic') ;
				x.src=ftpsrc+picsrc;
			}

		}

	})
	var bDelete = new Ext.Toolbar.Button({
		text : 'ɾ��ѡ��ͼƬ',
		tooltip : 'ɾ��ѡ��ͼƬ',
		iconCls : 'page_delete',
		handler : function() {
			var arrpicr = picView.getSelectedRecords() // ����
			if ((!arrpicr)||(arrpicr.length==0) ) {
				Msg.info("warning", '��ѡ��Ҫɾ����ͼƬ!');
				return;
			}
			var picr = arrpicr[0];
			var row = picr.get("rowid");
			var picsrc = picr.get("picsrc");

			FnDelete(row, picsrc);
			Store.remove(picr);
			picView.refresh();

		}
	});
	var exitBt=new Ext.Toolbar.Button({
		text:'�˳�',
		iconCls : 'page_goto',
		handler:function()
		{		
			PicWin.hide();
		}
	});

	
	
	// var fileBt=new Ext.Toolbar.Button({
		// text:'ͼƬ���¹鵵Ϊ:',
		// iconCls : 'page_link',
		// handler:function()
		// {
			// var typeDesc=Ext.getCmp('fileTypeValue').getRawValue();
			// var typeValue=Ext.getCmp('fileTypeValue').getValue();
			// if (typeValue=='')
			// {
				// Msg.info("warning", '��ѡ�����¹鵵������!');
				// Ext.getCmp('fileTypeValue').focus();
				// return;
			// }
			
			// var arrpicr = picView.getSelectedRecords() // ����
			// if ((!arrpicr)||(arrpicr.length==0))
			// {
				// Msg.info("warning", '��ѡ��ͼƬ!');
				// return;
			// }
			// var picr=arrpicr[0];
			// var row = picr.get("rowid");
			// var picsrc =picr.get("picsrc");
			// var typeName=picr.get("type");	
			
			// if (typeDesc==typeName)
			// {
				// Msg.info('error','�뵱ǰ������ͬ����ѡ���������ʣ�')	;
				// Ext.getCmp('fileTypeValue').setValue('');			
				// Ext.getCmp('fileTypeValue').focus();
			// }
			// else
			// {				
				// Ext.Ajax.request({
					// url:"dhcstm.apcvendoraction.csp?actiontype=UpdatePicInfo&rowid="+row+"&type="+typeValue,
					// success:function(result, request){
						// var jsonData = Ext.util.JSON.decode( result.responseText );
						// if (jsonData.success=='true')
						// {
							// Msg.info('success','ִ�гɹ�');						
							// Store.reload();
						// }
						// else
						// {
							// Msg.info('error','ִ��ʧ��');
						// }
					// },
					// failure:function()
					// {
						// Msg.info('error','ִ��ʧ��');
					// }
				// })
			// }
		// }
	// });	
	
	
	
	var nextB=new Ext.Toolbar.Button({
		text:'���>>',
		handler:function()
		{
			var selArr=picView.getSelectedIndexes();
			
			if (selArr.length>0)
			{			 
				picView.select(selArr[0]+1,false);
				var d = detailPanel.body.dom;			
				var cnt=picView.getStore().getCount();	
				if (cnt>0)
				{
					var x=(d.scrollHeight/cnt)*(selArr[0]+1);
					d.scrollTop = x   ;
				}
				
			}
			else
			{
				picView.select(0);
				if (d){
				d.scrollTop=0;
				}
			}
		}
	});
	
	var priorB=new Ext.Toolbar.Button({
		text:'<<��ǰ',
		handler:function()
		{
			var selArr=picView.getSelectedIndexes();
			
			if (selArr.length>0)
			{			 
				picView.select(selArr[0]-1,false);
				var d = detailPanel.body.dom;			
				var cnt=picView.getStore().getCount();	
				if (cnt>0)
				{
					var x=(d.scrollHeight/cnt)*(selArr[0]-1);
					d.scrollTop= x   ;
				}
			}
			else
			{
				picView.select(0);
				d.scrollBottom=0;
			}
		}
	});
	
	var detailPanel = new Ext.Panel({
		region:'west',
		minWidth:150,
		width:150,
		autoScroll : true,
		split:true,
		collapsible:true,
		//tbar : ['->',displayAllPic,'-',bDelete,'-',fileBt,fileCom,'-',exitBt],
		items : picView,
		bbar:new Ext.Toolbar({items:['->',priorB,'-',nextB]})
		
		 
	});
	var zoom=new Ext.Toolbar.Button({	
		text:'ssssssssss',
		handler:function(){
			var img=document.getElementById("pic");
			//alert(img);	
			//img.width=150;	  
			   img.width= detailPanelOne.getWidth()-50;   
	 img.height= detailPanelOne.getHeight()-50;
		}
		
	})
		
	var detailPanelOne = new Ext.Panel({
		region:'center',
		split:true
		,
		html:'<img id="pic" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		,tbar:new Ext.Toolbar({})
	});
	
	var closeBt=new Ext.Button({
		text:'�ر�'
		,
		iconCls:'page_delete',
		handler:function(){
			Ext.getCmp('saPicWin').hide();
		}
	});
	if(!PicWin){ 
		PicWin = new Ext.Window({
			title : 'ͼƬ��Ϣ',
			id:'saPicWin',
			//width : 820,
			width:gWinWidth,
			//height : 600,
			height: gWinHeight,
			maximizable:true,
			modal : true,
			tbar:[closeBt],
			closeAction:'hide',
			layout : 'border',
			sa:sa,
			 listeners:{
	   	      'show':function(){
	       	    
				  Store.removeAll();
				  // alert(this.sa);
	       	      Store.load({params:{'sa':this.sa}});
	   		 }
			 },
			
			items : [detailPanel,detailPanelOne]
		});	
		PicWin.show();
	}
	
}