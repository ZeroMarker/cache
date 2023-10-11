/**
 * @author Administrator
 */
/*
 * grid.store.on('load', function() {
 * grid.el.select("table[class=x-grid3-row-table]").each(function(x) {
 * x.addClass('x-grid3-cell-text-visible'); }); });
 * 
 * grid.getStore().on('load',function(s,records){ var girdcount=0;
 * s.each(function(r){ if(r.get('10')=='数据错误'){
 * grid.getView().getRow(girdcount).style.backgroundColor='#F7FE2E'; }
 * girdcount=girdcount+1; }); //scope:this });
 */
var grid;
var recId;
var locdata = new Array();
var modledata = new Array();
	var getmouldext=document.getElementById("getmouldext");
		
	var itmmould = cspRunServerMethod(getmouldext.value);
	var centeritem = new Ext.Panel({
		                x:200,
		                y:0,
						border : false,
						width : 225,
						layout : "accordion",
						extraCls : "roomtypegridbbar",
						// 添加动画效果
						layoutConfig : {
							animate : true
						},
					//	title : 'My Money导航',
						items : eval(itmmould)

					});
	/*		var getmould=document.getElementById("getmould");
			var mould = cspRunServerMethod(getmould.value);
			var mouldarr = mould.split('^')
			for (i = 0; i < mouldarr.length; i++) {
				itm = mouldarr[i].split('|');
				if (mouldarr[i] == "")
					continue;
				var root = new Ext.tree.AsyncTreeNode({	});
				var tree1 = new Ext.tree.TreePanel({
							renderTo : itm[0],
							root : root,// 定位到根节点
							autoScroll: true,
							height:285,
						    containerScroll: true,
							animate : true,// 开启动画效果
							enableDD : true,// 不允许子节点拖动
							border : true,// 没有边框
							rootVisible : true,// 设为false将隐藏根节点，很多情况下，我们选择隐藏根节点增加美观性
							loader : new Ext.tree.TreeLoader({
										dataUrl : "../web.DHCMgNurMenu.cls?mouldid="
												+ itm[1]
									})

						});
				tree1.expandAll();


			}
*/
function initree()
{
		var getmould=document.getElementById("getmould");
			var mould = cspRunServerMethod(getmould.value);
			var mouldarr = mould.split('^')
			for (i = 0; i < mouldarr.length; i++) {
				itm = mouldarr[i].split('|');
				if (mouldarr[i] == "")
					continue;
				var root = new Ext.tree.AsyncTreeNode({	});
				var tree1 = new Ext.tree.TreePanel({
							renderTo : itm[0],
							root : root,// 定位到根节点
							autoScroll: true,
							height:285,
						    containerScroll: true,
							animate : true,// 开启动画效果
							enableDD : true,// 不允许子节点拖动
							border : true,// 没有边框
							rootVisible : true,// 设为false将隐藏根节点，很多情况下，我们选择隐藏根节点增加美观性
							loader : new Ext.tree.TreeLoader({
										dataUrl : "../web.DHCMgNurMenu.cls?mouldid="
												+ itm[1]
									})

						});
				tree1.expandAll();


			}
}
function BodyLoadHandler() {
	//setsize("mygridpl", "gform", "mygrid");
	var fm = Ext.getCmp('gform');
	fm.add(centeritem);
	
	var but1 = Ext.getCmp("mygridbut1");
	but1.hide();
	var but = Ext.getCmp("mygridbut2");
	but.setText("保存");
	but.hide();
	
	grid = Ext.getCmp('mygrid');
	initree();
}