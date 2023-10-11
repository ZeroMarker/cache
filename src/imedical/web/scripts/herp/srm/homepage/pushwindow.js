Ext.ns('Ext.ux');
/**
* ���½ǵ�С��ʿ����
* @author tipx.javaeye.com
* @params conf �ο�Ext.Window
* conf�����autoHide������, Ĭ��3���Զ�����, �����Զ����ص�ʱ��(��λ:��), ����Ҫ�Զ�����ʱ����Ϊfalse
* @ע: ʹ�ö�����window������(manager:new Ext.WindowGroup()), �ﵽ������ʾ����ǰ��Ч��
*/
; (function($)
{
//�½�window�飬���ⱻ����windowӰ����ʾ����ǰ��Ч��
var tipsGroupMgr = new Ext.WindowGroup();
tipsGroupMgr.zseed = 99999; //��С��ʿ����ǰ��
$.TipsWindow = Ext.extend(Ext.Window,
{
width: 500,
height: 150,
layout: 'fit',
modal: false,
plain: true,
shadow: false,
//ȥ����Ӱ
draggable: false,
//Ĭ�ϲ�����ק
resizable: false,
closable: true,
closeAction: 'hide',
//Ĭ�Ϲر�Ϊ����
autoHide: 3,
count:1,//������ʾ���ǵڼ���tipwindow
//n����Զ����أ�Ϊfalseʱ,���Զ�����
manager: tipsGroupMgr,
//����window��������
constructor: function(conf)
{
$.TipsWindow.superclass.constructor.call(this, conf);
this.initPosition(true);
},
initEvents: function()
{
$.TipsWindow.superclass.initEvents.call(this);
//�Զ�����
if (false !== this.autoHide)
{
var task = new Ext.util.DelayedTask(this.hide, this),
second = (parseInt(this.autoHide) || 3) * 1000;
this.on('beforeshow',
function(self)
{
task.delay(second);
});
}
this.on('beforeshow', this.showTips);
this.on('beforehide', this.hideTips);
Ext.EventManager.onWindowResize(this.initPosition, this); //window��С�ı�ʱ��������������
Ext.EventManager.on(window, 'scroll', this.initPosition, this); //window�ƶ�������ʱ��������������
},
//����: flag - trueʱǿ�Ƹ���λ��
initPosition: function(flag)
{
if (true !== flag && this.hidden)
{ //���ɼ�ʱ������������
return false;
}
var doc = document,
bd = (doc.body || doc.documentElement);
//extȡ���ӷ�Χ���(�����淽��ȡ��ֵ��ͬ), ���Ϲ�������
var left = bd.scrollLeft + Ext.lib.Dom.getViewWidth() - 4 - this.width;
var top = bd.scrollTop + Ext.lib.Dom.getViewHeight() - 4 - this.height*this.count;
this.setPosition(left, top);
},
showTips: function()
{
var self = this;
if (!self.hidden)
{
return false;
}
self.initPosition(true); //��ʼ������
self.el.slideIn('b',
{
callback: function()
{
//��ʾ��ɺ�,�ֶ�����show�¼�,����hidden��������false,���򽫲��ܴ���hide�¼�
self.fireEvent('show', self);
self.hidden = false;
}
});
return false; //��ִ��Ĭ�ϵ�show
},
hideTips: function()
{
var self = this;
if (self.hidden)
{
return false;
}
self.el.slideOut('b',
{
callback: function()
{
//��������ִ�����ʱ,�ֶ�����hide�¼�,����hidden��������true
self.fireEvent('hide', self);
self.hidden = true;
}
});
return false; //��ִ��Ĭ�ϵ�hide
}
});
})(Ext.ux);

