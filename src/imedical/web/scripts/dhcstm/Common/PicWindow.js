/**
 * 名称: 图片展示窗口
 * 
 * 描述: 编写者：xuchao 编写日期: 2014.5.22
 * 
 * @param {}
 *            store 中包含的字段 rowid 删除时对应的rowid  picsrc 图片的路径
 *
 * @param {}
 *            Fndelete 调用界面方法句柄，删除数据库中图片信息
 */
 var cus=null
// var PicWin=null
 var gParam=[]; 

/*
 * creator:zhangdongmei,2012-09-26
 * description:取入库相关界面涉及的参数配置保存到全局变量gParam
 * params: 
 * return: 
 * */
function GetParam(){
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var locId=session['LOGON.CTLOCID'];
	var url='dhcstm.ftpcommon.csp?actiontype=GetParamProp&GroupId='+groupId+'&LocId='+locId+'&UserId='+userId;
	var response=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(response);
	if(jsonData.success=='true'){
		var info=jsonData.info;
		if(info!=null || info!=''){
			gParam=info.split('^');
		}
	}

	return;
}

	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}
ShowPicWindow = function(Store,FnDelete) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var ftpsrc="http://"+gParam[5]
	var imginit=function(){
		 Ext.DomHelper.insertHtml('afterBegin',Ext.getDom('mainpanel'),'<img id="custom"/>')
	
	}

	//imginit() ////给Resizable用的dom

	var mainPichtml =function(src){
				var html = '<img id="mainpic" src="'+ftpsrc+src+'" style="position: relative;max-height:100px; max-width:100px;">';
				return html;
			};//图片内容
	//cus //声明一个全局变量

	var picTpl = new Ext.XTemplate(
			'<tpl for=".">',
			'<div style="padding:5px; height:260px; width:260px; float:left;" class="select_pic" >',
			'<img  class="pic" src="'+ftpsrc+'{picsrc}"style="height:250px; width:250px;"position: relative;>',
			'</div>',
			'</tpl>');

	var picView = new Ext.DataView({
				store:Store,
				tpl:picTpl,
			    frame:true,
				singleSelect : true,
				trackOver : true,
				selectedClass:'selected-pic',
				overClass:'over-pic',
				itemSelector:'div.select_pic',
				emptyText : '没有图片',
				listeners : {
					'dblclick':function(v, r) {
						var src=Store.getAt(r).get('picsrc')
						Ext.get("custom").dom.src=ftpsrc+src;
						////获取图片的实际大小
						var image = new Image();
      					image.src = ftpsrc+src;
      					document.body.appendChild(image);
      					
				
					//Ext.get("custom").dom.style="position:absolute;left:0;top:0;width:400px;height:300px;"
	                if(!cus){
						cus = new Ext.Resizable("custom", {
    					wrap:true,
    					pinned:true,
    					preserveRatio: true,
    					dynamic:true,
    					handles: 'all', // shorthand for 'n s e w ne nw se sw'
    					draggable:true
					});
					
					var customEl =cus.getEl();
        			//document.body.insertBefore(customEl.dom,document.body.firstChild);
        			customEl.on('dblclick',function(){
        			cus.resizeTo (1,1)
        			PicWin.show()
        			});
	        	}       
	                (function(){
	                var height=800                                ///设置默认高度
	                var width=image.width/(image.height/height)  ///按照比例缩放  防止变形
	                cus.resizeTo (width,height);
	                PicWin.hide()
	                })()
        			//customEl.center();
        			//customEl.show(true);
					}

				}

			})
   var bDelete=new Ext.Toolbar.Button({
			text : '删除选中图片',
			tooltip : '删除选中图片',
			iconCls : 'page_goto',
			handler : function() {
				var arrpicr=picView.getSelectedRecords() //数组
				if(!arrpicr){Msg.info("warning",'请选择要删除的图片!');return}
				var picr=arrpicr[0]
				var row=picr.get("rowid")
				var picsrc=picr.get("picsrc")
			
				FnDelete(row,picsrc)
				Store.remove(picr)
				picView.refresh()
				
				}
			});
 
	var detailPanel = new Ext.Panel({
		autoScroll:true,
		tbar:[bDelete],
		items:picView                                 
	});
	
	var PicWin = new Ext.Window({
				title : '图片信息',
				width : 800,
				height : 600,
				layout : 'fit',
				//closeAction:'hide',
				plain : true,
				modal : true,
				items : [detailPanel]
			});
	
	PicWin.show()
}