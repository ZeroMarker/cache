/**
 * Ext.ux.ToastWindow
 *
 * @author  Edouard Fattal
 * @date	March 14, 2008
 *
 * @class Ext.ux.ToastWindow
 * @extends Ext.Window
 */

Ext.namespace("Ext.ux");


Ext.ux.NotificationMgr = {
	positions: []
};

Ext.ux.Notification = Ext.extend(Ext.Window, {
	initComponent: function(){
		Ext.apply(this, {
			iconCls: this.iconCls || 'x-icon-information',
			cls: 'x-notification',
			width: 200,
			autoHeight: true,
			plain: false,
			draggable: false,
			autoHide :  this.autoHide && true, //�Ƿ��Զ����ش���
			hideDelay: this.hideDelay || 3000 ,//����Զ����أ�n��������ش��ڡ�autoHideΪtrue��hideDelay������
			minimizable:false,
			constrain:true,
			bodyStyle: 'text-align:left'
		});
		if(this.autoHide) {
			this.task = new Ext.util.DelayedTask(this.hideWin, this);
		}
		Ext.ux.Notification.superclass.initComponent.call(this);
	},
	hideWin:function(){
				this.hide();
				this.close();//�رյ�ǰ����
	},
	setMessage: function(msg){
		this.body.update(msg);
	},
	setTitle: function(title, iconCls){
		Ext.ux.Notification.superclass.setTitle.call(this, title, iconCls||this.iconCls);
	},
	onRender:function(ct, position) {
		Ext.ux.Notification.superclass.onRender.call(this, ct, position);
	},
	minimize:function(){
		if(this.minimizable){
			this.hideWin();
		}
	},
	onDestroy: function(){
		Ext.ux.NotificationMgr.positions.remove(this.pos);
		Ext.ux.Notification.superclass.onDestroy.call(this);
	},
	cancelHiding: function(){
		this.addClass('fixed');
		if(this.autoHide) {
			this.task.cancel();
		}
	},
	afterShow: function(){
		Ext.ux.Notification.superclass.afterShow.call(this);
		Ext.fly(this.body.dom).on('click', this.cancelHiding, this);
		if(this.autoHide) {
			this.task.delay(this.hideDelay || 3000);
	   }
	},
	animShow: function(){
		this.pos = 0;
		while(Ext.ux.NotificationMgr.positions.indexOf(this.pos)>-1)
			this.pos++;
		Ext.ux.NotificationMgr.positions.push(this.pos);
		this.setSize(200,100);
		this.el.alignTo(document, "br-br", [ -20, -20-((this.getSize().height+10)*this.pos) ]);
		this.el.slideIn('b', {
			duration: 1,
			callback: this.afterShow,
			scope: this
		});
	},
	animHide: function(){
		   Ext.ux.NotificationMgr.positions.remove(this.pos);
		this.el.ghost("b", {
			duration: 1,
			remove: true
		});
	},
	
	/**
	 * ���÷����������ɹ�����ʾ�ɹ�����Ϣ
	 * @param {} title
	 * @param {} msg
	 */
	showSuccess:function(title,msg){
		this.iconCls=	'x-icon-information',
		this.title = title||'success';
		this.html = msg||'process successfully!';
		this.show(document);	
	},
	/**
	 * ���÷���������ʧ�ܣ���ʾʧ�ܵ���Ϣ
	 * @param {} title
	 * @param {} msg
	 */
	showFailure:function(title,msg){
		this.iconCls=	'x-icon-error',
		this.title = title||'success';
		this.html = msg||'process successfully!';
		this.show(document);	
	},
	/**
	 * ���÷�������ʾ�����������Ϣ
	 * @param {} title
	 * @param {} msg
	 * @param {} success �����Ƿ�ɹ�
	 */
	showMessage:function(title,msg,success){
		if(success){
			this.iconCls=	'x-icon-information';
			this.autoHide=true;//�Զ����ش���
			this.task = new Ext.util.DelayedTask(this.hideWin, this);
		}
		else{
			this.iconCls=	'x-icon-error';
			}
			this.title = title;
			this.html = msg;
			this.show(document);			
	},
	focus: Ext.emptyFn 

}); 
var msgNotification;
var entch=document.getElementById("checkNewMessage");
function popMessage(){
	var link="<a href=\"javascript:msgNotification.close(); var win=websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=SSMessageRecipient.List&User=";
	link+=session['LOGON.USERCODE'];
	link+="','messages','top=10,left=10,width=300,height=300,status=yes,scrollbars=yes,resizable=yes')\" style='color:red'><img SRC='../images/webemr/message.gif' BORDER=0>"

	var cnt="0";
	if (!entch){
		entch=document.getElementById("checkNewMessage");
	}
	cnt=cspRunServerMethod(entch.value,session['LOGON.USERID']);
    //var cnt=objMessageService.countNewMessages(session['LOGON.USERID']);
    if (eval(cnt)>0){
	    var msg=link+cnt+"����Ϣ</a></br>";
	    //msgNotification=Ext.get("msgNotification");
	    if (msgNotification){
		    if (!msgNotification.isDestroyed){
			    msgNotification.setMessage(msg);
			}
			else{
				msgNotification=null;
			}
	    }
	    if (!msgNotification){
	    	msgNotification=new Ext.ux.Notification({id:'msgNotification'}); 
	    	msgNotification.showMessage("��Ϣ��ʾ��",msg,false); 
		}
	}
}
