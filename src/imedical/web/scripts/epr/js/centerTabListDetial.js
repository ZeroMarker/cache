function getBBar() {
	var bbar = new Ext.Toolbar({
				border : false,
				items : [{
							id : 'btnReference',
							text : '病历引用',
							handleMouseEvents : false,
							cls : 'x-btn-text-icon',
							icon : '../scripts/epr/Pics/btnReference.gif',
							pressed : false,
							listeners : {
								'click' : function() {
									reference();
								}
							}
						}, '->', '-', {
							id : 'btnSave',
							text : '保存',
							handleMouseEvents : false,
							cls : 'x-btn-text-icon',
							icon : '../scripts/epr/Pics/save.gif',
							pressed : false,
							listeners : {
								'click' : function() {
									save();
								}
							}
						}, '-', {
							id : 'btnCommit',
							text : '提交',
							handleMouseEvents : false,
							cls : 'x-btn-text-icon',
							icon : '../scripts/epr/Pics/submission.gif',
							pressed : false,
							handler : commit
						}, '-', {
							id : 'btnUpdateData',
							text : '更新数据',
							handleMouseEvents : false,
							cls : 'x-btn-text-icon',
							icon : '../scripts/epr/Pics/upda.gif',
							pressed : false,
							handler : update
						}, '-', {
							id : 'btnUpdateTemplate',
							text : '更新模板',
							handleMouseEvents : false,
							cls : 'x-btn-text-icon',
							icon : '../scripts/epr/Pics/updaTemplate.gif',
							pressed : false,
							handler : updateTemplate
						}]
			});
	if (1) {
		bbar.render(Ext.getBody());
		bbar.addSeparator();
		bbar.addButton(new Ext.Toolbar.Button({
					id : 'btnOnRecChiefCheck',
					text : '主任医师审核',
					handleMouseEvents : false,
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/chief.gif',
					pressed : false,
					handler : onRecChiefCheck
				}));
		bbar.addSeparator();
		bbar.addButton(new Ext.Toolbar.Button({
					id : 'btnOnRecAttendingCheck',
					text : '主治医师审核',
					handleMouseEvents : false,
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/attending.gif',
					pressed : false,
					handler : onRecAttendingCheck
				}));
	}
	if (parent.parent.IsCAOn()) {
		bbar.render(Ext.getBody());
		bbar.addSeparator();
		bbar.addButton(new Ext.Toolbar.Button({
					id : 'btnSigniture',
					text : '数字签名',
					handleMouseEvents : false,
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/btnSigniture.gif',
					pressed : false,
					handler : signiture
				}));
		bbar.addSeparator();
		bbar.addButton(new Ext.Toolbar.Button({
					id : 'btnVerifySign',
					text : '签名验证',
					handleMouseEvents : false,
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/btnVerifySign.gif',
					pressed : false,
					listeners : {
						'click' : function() {
							verify();
						}
					}
				}));
	}
	if (isHandWrittenSignPage=="1") {
		bbar.render(Ext.getBody());
		bbar.addSeparator();
		bbar.addButton(new Ext.Toolbar.Button({
					id : 'btnHandSign',
					text : '患者签名',
					handleMouseEvents : false,
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/btnHandSign.png',
					pressed : false,
					//handler : handWrittenSign
					handler : anySign
				}));
		bbar.addSeparator();
		bbar.addButton(new Ext.Toolbar.Button({
					id : 'btnHandSign',
					text : '验证患者签名',
					handleMouseEvents : false,
					cls : 'x-btn-text-icon',
					icon : '../scripts/epr/Pics/btnHandSign.png',
					pressed : false,
					handler : anySignVerify
				}));
	}
	if (parent.parent.IsRecyclerOn()) 
	{
		bbar.render(Ext.getBody());
		bbar.addSeparator();
		bbar.addButton(new Ext.Toolbar.Button({
							id : 'btnDel',
							text : '删除',
							handleMouseEvents : false,
							cls : 'x-btn-text-icon',
							icon : '../scripts/epr/Pics/Dump_small.png',
							pressed : false,
							handler: delChart
						}));
	}
	return bbar;
}

function getTBar() {
	var tbar = new Ext.Toolbar({
				height : 28,
				border : false
			});
	return tbar;
}

function getCenterTabVPort() {

	var frmMainContent = new Ext.Viewport({
		id : 'centertabviewport',
		shim : false,
		animCollapse : false,
		constrainHeader : true,
		margins : '0 0 0 0',
		layout : 'border',
		items : [{
			border : false,
			region : 'center',
			layout : 'border',
			items : [
					// delete by loo on 2010-4-16
					/*
					 * { border: false,region: 'north',height: 27, layout:
					 * 'column',border:false, items: [ { border:
					 * false,columnWidth:1, height: 27, html: '<div
					 * id="divInfoParent"><div id="divInfo"></div></div>'}
					 * //{ border: false,columnWidth:1, height: 27, items:
					 * getTBar()} ] },
					 */
					{
				border : false,
				region : 'center',
				layout : 'fit',
				html : _IframeScript
			}, {
				border : false,
				region : 'south',
				layout : 'column',
				height : 46,
				items : [{
							border : false,
							columnWidth : 1,
							height : 27,
							items : getBBar()
						}, {
							border : false,
							columnWidth : 1,
							height : 24,
							html : '<div id="divStateParent" class="divStateParent"><div id="divState" style= "float:left;line-height:15px;"></div><div id="divDetail" style= "float:right;width:32px"><img alt="" style="cursor:pointer;margin-top:2px;" src="../scripts/epr/Pics/browser.gif" onClick="showLog()" /></div></div>'
						}]
			}]
		}]
	});

}
getCenterTabVPort();// alert(pateintID+" "+episodeID+" "+chartItemID);

// add by loo on 2010-7-27
// 历次模板保存(F7)?提交(F8)操作添加快捷键
// debugger;
var map = new Ext.KeyMap(Ext.getDoc(), {
			key : 118, // F7
			fn : function() {
				save();
			},
			scope : this
		});

map.addBinding({
			key : 119, // F8
			fn : function() {
				commit();
			},
			scope : this
		});