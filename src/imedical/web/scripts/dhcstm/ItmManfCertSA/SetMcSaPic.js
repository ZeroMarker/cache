/**f
 * 名称: 图片展示窗口
 
 */
var cus = null;
var PicWin=null;
var saPicWin=null;
var gParam = [];
var saTakePicWindow;
var mcTakePicWindow;

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
	GetParam(); // 初始化参数配置
}
 //编辑注册证图片
function EditMcPic(Store,mc)
{   
	currentMc=mc;
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
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc = "http://" + gParam[5];

	if (PicWin)
	{
		PicWin.show();
		return;
	}
					
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div style="padding:5px; height:130px; width:100px; float:left;" class="select_pic" >',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:100px; width:100px;"position: relative;>',
		'<p>{type}:({certNo})</p>',		
		'</div>', '</tpl>');

	var picTpl2 = new Ext.XTemplate(
		'<tpl for=".">',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:150px; width:160px;"position: relative;>',
		'<p>{type}</p>',		
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
		emptyText : '请选择要显示的资质图片',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
				Ext.get("custom").dom.src = ftpsrc + src;
				// //获取图片的实际大小
				var image = new Image();
				image.src = ftpsrc + src;
				document.body.appendChild(image); //加载图片
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
				var height = 600 ;// /设置默认高度
				var width = image.width / (image.height / height)  ;// /按照比例缩放
																	// 防止变形
				cus.resizeTo(width, height);
				PicWin.hide();
			},
			'selectionchange':function(v,arrpicr)
			{
				var arrpicr = v.getSelectedRecords(); // 数组
				if (arrpicr.length<1) return;
				var picr = arrpicr[0];
				// var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");				
				var x=document.getElementById('pic') ;
				x.src=ftpsrc+picsrc;
			}

		}

	});
	var bAdd=new Ext.Toolbar.Button({
		text:'增加图片',
		tooltip : '增加图片',
		iconCls : 'page_add',
		handler:function()
		{
			var type="";
			var mc=currentMc;
			addMCPic(mc,type);
		
			
		}
	});
	var bMcTakePhoto=new Ext.Toolbar.Button({
		text:'拍照',
		tooltip : '注册证拍照',
		iconCls : 'page_add',
		handler:function()
		{
			var type=currentType;
			var sa=currentMc;
			take_pic_mc(currentMc,currentType);
		
		}
	});	
	function addMCPic(mc,type){
		var dialog = new Ext.ux.UploadDialog.Dialog({
			width : 600,
			height : 400,
			url: 'dhcstm.itmmanfcertsaaction.csp?actiontype=uploadMCPic&mc='+mc+"&type="+type, 
			reset_on_hide: false,
			permitted_extensions:['gif','jpeg','jpg','png','bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title:'上传注册证图片',
			base_params : {'type':type,'mc':mc},
			listeners:{
				'uploadcomplete':function()
				{
					Store.reload();}
			}
			//post_var_name: 'file'
		});
		dialog.show();
	};	
	
	///删除MC图片
	var FnDelete=function(rowid,picsrc)
	{
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:'dhcstm.itmmanfcertsaaction.csp?actiontype=deleteMCPic&rowid='+rowid+'&picsrc='+picsrc,
			waitMsg:'删除中...',
			failure: function(result, request) {
				 mask.hide();
				Msg.info("error", "请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success", "删除成功!");
		  
				}else{ 
						Msg.info("error", "删除失败!");
				}
			},
			scope: this
		});
	}
	
	var bDelete = new Ext.Toolbar.Button({
		text : '删除选中图片',
		tooltip : '删除选中图片',
		iconCls : 'page_delete',
		handler : function() {
			var arrpicr = picView.getSelectedRecords() // 数组
			if ((!arrpicr)||(arrpicr.length==0) ) {
				Msg.info("warning", '请选择要删除的图片!');
				return;
			}
			var picr = arrpicr[0];
			var row = picr.get("rowid");
			var picsrc = picr.get("picsrc");

			FnDelete(row, picsrc);
			Store.remove(picr);
			Store.reload();
			// picView.refresh();

		}
	});
	var exitBt=new Ext.Toolbar.Button({
		text:'关闭',
		iconCls : 'page_goto',
		handler:function()
		{		
			PicWin.hide();
		}
	});
		
	var nextB=new Ext.Toolbar.Button({
		text:'向后>>',
		handler:function()
		{
			var selArr=picView.getSelectedIndexes();
			var d = detailPanel.body.dom;				
			if (selArr.length>0)
			{			 
				picView.select(selArr[0]+1,false);
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
				d.scrollTop=0;
			}
		}
	});
		
	var priorB=new Ext.Toolbar.Button({
		text:'<<向前',
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
				var d = detailPanel.body.dom;
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

		
	var detailPanelOne = new Ext.Panel({
		region:'center',
		autoScroll : true,
		split:true,
		//html:'<iframe id="pic" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		html:'<img id="pic" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		,tbar:new Ext.Toolbar({items:[]})
	});
	
	function take_pic_mc(mc,type)
	{
		if (mc=="") return;
		var AppName = 'ManfCert';
		if ((!mcTakePicWindow)||(mcTakePicWindow.closed))
		{
			var lnk='dhcstm.takepiccommon.csp';
			lnk=lnk+"?AppName="+AppName;
			lnk=lnk+"&RowId="+mc;
			lnk=lnk+"&typeCode="+type;
			// lnk=lnk+"&typeDesc="+typeDesc;
			lnk=lnk+"&GroupId="+session['LOGON.GROUPID'];
			lnk=lnk+"&LocId="+session['LOGON.CTLOCID'];
			lnk=lnk+"&UserId="+session['LOGON.USERID'];
			mcTakePicWindow=window.open(lnk,"take_photo","height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");		
		}
		else
		{
			mcTakePicWindow.SetType(AppName,mc,type,"",session['LOGON.GROUPID'],session['LOGON.CTLOCID'],session['LOGON.USERID']);
			mcTakePicWindow.focus();
		}
	}
	if(!PicWin){ 
		PicWin = new Ext.Window({
			title : '图片信息',
			//width : 820,
			width:gWinWidth,
			//height : 600,
			height: gWinHeight,
			maximizable:true,
			tbar:[bAdd,'-',bMcTakePhoto,'-',bDelete,'-',exitBt],
			modal : true,
			closeAction:'hide',
			layout : 'border',
			 listeners:{
			  'show':function(){
				  Store.removeAll();
				  Store.load({params:{'mc':currentMc}});
				  // displayAllPic.handler();
			 }
			 },
			
			items : [detailPanel,detailPanelOne]
		});	
	}
	PicWin.show();
}


//编辑授权图片
function EditSaPic(Store,mode,sa,ven,venName,picType)
{
	currentSa=sa;
	currentVen=ven;
	currentVenName=venName;
	currentMode=mode;
	currentType=picType;

	Store.on('load',function(){
		var cnt=Store.getCount();
		if (cnt==0) 
		{
			var x=document.getElementById('sapic') ;
			x.src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";	
		}
		else
		{
			picView.select(0);
		}	
	});
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc = "http://" + gParam[5];

	if (saPicWin)
	{
		saPicWin.show();
		return;
	}
					
	var picTpl = new Ext.XTemplate(
		'<tpl for=".">',
		'<div style="padding:5px; height:130px; width:100px; float:left;" class="select_pic" >',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:100px; width:100px;"position: relative;>',
		'<p>{type}({venName})</p>',		
		'</div>', '</tpl>');

	var picTpl2 = new Ext.XTemplate(
		'<tpl for=".">',
		'<img  class="pic" src="'
				+ ftpsrc
				+ '{picsrc}"style="height:150px; width:160px;"position: relative;>',
		'<p>{type}({venName})</p>',		
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
		emptyText : '请选择要显示的资质图片',
		listeners : {
			'dblclick' : function(v, r) {
				var src = Store.getAt(r).get('picsrc')
				Ext.get("custom").dom.src = ftpsrc + src;
				// //获取图片的实际大小
				var image = new Image();
				image.src = ftpsrc + src;
				document.body.appendChild(image); //加载图片
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
					saPicWin.show();
				});
				var height = 600 ;// /设置默认高度
				var width = image.width / (image.height / height)  ;// /按照比例缩放
																	// 防止变形
				cus.resizeTo(width, height);
				saPicWin.hide();
			},
			'selectionchange':function(v,arrpicr)
			{
				var arrpicr = v.getSelectedRecords(); // 数组
				if (arrpicr.length<1) return;
				var picr = arrpicr[0];
				// var row = picr.get("rowid");
				var picsrc = picr.get("picsrc");				
				var x=document.getElementById('sapic') ;
				x.src=ftpsrc+picsrc;
			}

		}

	});
	var bAdd=new Ext.Toolbar.Button({
		text:'增加图片',
		tooltip : '增加图片',
		iconCls : 'page_add',
		handler:function()
		{
			var type=currentType;
			var sa=currentSa;
			var ven=currentVen;
			var dialog = new Ext.ux.UploadDialog.Dialog({
				width : 600,
				height : 400,
				url: 'dhcstm.itmmanfcertsaaction.csp?actiontype=uploadSAPic&sa='+sa+"&type="+type+"&ven="+ven, 
				reset_on_hide: false,
				permitted_extensions:['gif','jpeg','jpg','png','bmp'],
				allow_close_on_upload: true,
				upload_autostart: false,
				title:'上传图片',
				listeners:{
					'uploadcomplete':function()
					{
						Store.reload();}
					},
				base_params : {'type':type,'sa':sa,'ven':ven}
				//post_var_name: 'file'
			});
			dialog.show();			
		}
	});

	

	
	
	var bSaTakePhoto=new Ext.Toolbar.Button({
		text:'拍照',
		tooltip : '拍照',
		iconCls : 'page_add',
		handler:function()
		{
			var type=currentType;
			var sa=currentSa;
			var ven=currentVen;
			take_pic_sa(currentSa,currentVen,currentType);
		}
	});
	
	function take_pic_sa(sa,ven,type)
	{
		if (sa=="") return;
		var AppName = 'ManfCertSA';
		if ((!saTakePicWindow)||(saTakePicWindow.closed))
		{
			var lnk='dhcstm.takepiccommon.csp';
			lnk=lnk+"?AppName="+AppName;
			lnk=lnk+"&RowId="+sa;
			lnk=lnk+"&VendorId="+ven;
			lnk=lnk+"&typeCode="+type;
			// lnk=lnk+"&typeDesc="+typeDesc;
			lnk=lnk+"&GroupId="+session['LOGON.GROUPID'];
			lnk=lnk+"&LocId="+session['LOGON.CTLOCID'];
			lnk=lnk+"&UserId="+session['LOGON.USERID'];
			saTakePicWindow=window.open(lnk,"take_photo","height=600,width=800,top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=yes");		
		}
		else
		{
			saTakePicWindow.SetType(AppName,sa,type,"",session['LOGON.GROUPID'],session['LOGON.CTLOCID'],session['LOGON.USERID'],ven);
			saTakePicWindow.focus();
		}
	}

	var bDelete = new Ext.Toolbar.Button({
		text : '删除选中图片',
		tooltip : '删除选中图片',
		iconCls : 'page_delete',
		handler : function() {
			var arrpicr = picView.getSelectedRecords() // 数组
			if ((!arrpicr)||(arrpicr.length==0) ) {
				Msg.info("warning", '请选择要删除的图片!');
				return;
			}
			var picr = arrpicr[0];
			var rowid = picr.get("rowid");
			var picsrc = picr.get("picsrc");
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			//删除SA图片
			Ext.Ajax.request({
				url:'dhcstm.itmmanfcertsaaction.csp?actiontype=deleteSAPic&rowid='+rowid+'&picsrc='+picsrc, 
				waitMsg:'删除中...',
				failure: function(result, request) {
					mask.hide();
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "删除成功!");
						Store.remove(picr);
						picView.refresh();
						if(picView.getNode(0)){
							picView.select(0);
						}else{
							var x=document.getElementById('sapic') ;
							x.src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
						}
					}else{ 
						Msg.info("error", "删除失败!");
					}
				},
				scope: this
			});			

		}
	});
 
	
	var exitBt=new Ext.Toolbar.Button({
		text:'关闭',
		iconCls : 'page_goto',
		handler:function()
		{		
			saPicWin.hide();
		}
	});
		
	var nextB=new Ext.Toolbar.Button({
		text:'向后>>',
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
				var d = detailPanel.body.dom;
				d.scrollTop=0;
			}
		}
	});
		
	var priorB=new Ext.Toolbar.Button({
		text:'<<向前',
		handler:function()
		{
			var selArr=picView.getSelectedIndexes();
			var d = detailPanel.body.dom;			
			if (selArr.length>0)
			{			 
				picView.select(selArr[0]-1,false);
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

		
	var detailPanelOne = new Ext.Panel({
		region:'center',
		autoScroll : true,
		split:true
		,
		//html:'<iframe id="pic" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		html:'<img id="sapic" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		,tbar:new Ext.Toolbar({items:[]})
	});
	

	if(!saPicWin){ 
		saPicWin = new Ext.Window({
			title : '授权资质图片',
			//width : 820,
			width:gWinWidth,
			//height : 600,
			height: gWinHeight,
			maximizable:true,
			tbar:[bAdd,'-',bSaTakePhoto,'-',bDelete,'-',exitBt],
			modal : true,
			closeAction:'hide',
			layout : 'border',
			 listeners:{
			  'show':function(t){
				  Store.removeAll();
				  Store.load({params:{'sa':currentSa,'ven':currentVen,'type':currentType}});
				  
				  if (currentMode==0){bAdd.setVisible(false);} //设置是否显示
				  else {bAdd.setVisible(true);}
					if (currentMode==0){bDelete.setVisible(false);}  //设置是否显示
					else {bDelete.setVisible(true);}
				if (currentVen!="")
				{
					t.setTitle("授权资质图片"+"("+currentVenName+")");
					
				}
				  // displayAllPic.handler();
			 }
			 },
			
			items : [detailPanel,detailPanelOne]
		});	
	}
	saPicWin.show();	
	
	
	
}	