//�������չ�������Ϣ�ı�����

function CreateRecinfowin(){
	if(win){
		win.show();
		return;
	}
    var reportPanel=new Ext.Panel({
	layout:'fit',
	html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})
	
    //��ʼ������
	win = new Ext.Window({
		title:'��������������Ϣ',
		width:1000,
		height:560,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:reportPanel,
		closeAction:'hide',
		listeners:{
			'show':function(){
				var reportFrame=document.getElementById("frameReport");
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_PayRec_Common.raq&payid='+payRowId;
     	     	reportFrame.src=p_URL;	
			}
		}
	});
	win.show();
	
}