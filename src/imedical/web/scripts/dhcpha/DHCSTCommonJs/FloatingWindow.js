/*

*/
var unitsUrl = 'dhcpha.comment.main.save.csp';
ExistStr="";

var openPreviewInfoWin = function()
{
	var retstr=showModalDialog('dhcpha.comment.autocheck.csp?ChkStr='+ExistStr,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:yes;menubar=no;toolbar=no;location=no')
};

var ShowPreviewWindow = function(){
	 
	new Ext.ux.Notification({
			icon:"../scripts/dhcpha/img/cancel.png",
			title:	  '��ʾ',
			html:	   "<a href='javascript:void(0)' onclick='openPreviewInfoWin()' >ע��:�ô������ظ���ҩ!<b></b><br><br><br><br><br></a>",
			autoDestroy: true,
			hideDelay:  3000
	}).show(document); 
};


var CheckArcExist = function(prescno){
	
	
		Ext.Ajax.request({
                        url: unitsUrl
                        		+ '?action=CheckArcExist&prescno='+prescno,
	
                        method:'GET',
						waitMsg: '������...',
                        failure: function(result, request){
                            Ext.Msg.show({
                                title: '����',
                                msg: '������������!',
                                buttons: Ext.Msg.OK,
                                icon: Ext.MessageBox.ERROR
                            });
                        },
                        success: function(result, request){
                            var jsonData = Ext.util.JSON.decode(result.responseText);
                            if (jsonData.success == 'true') {
								ExistStr=jsonData.info;
								
								if (ExistStr!=""){
									ShowPreviewWindow();	
								}
								
								 
                            }
                        },
                        scope: this
                    });
                   
	
}