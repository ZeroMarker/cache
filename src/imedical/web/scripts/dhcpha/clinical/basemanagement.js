/// Creator: bianshuai
/// CreateDate: 2014-09-18
//  Descript: ���ع���

var url="dhcpha.clinical.action.csp";
$(function(){
	
	$('#tabs').append('<div id="0" id="ScriptDiv" title="���ط��"></div>');
	///��ʼ��ѡ�
	$("#tabs").tabs({
		border:false,
	    fit:"true", 
	    onSelect:function(title){
		}
	});
	
	$('li').live('click',function(){
		var ListTitle=$('#'+this.id+" a").html();
		addAutoTab(ListTitle,this.id);
	})
})

/// ���ѡ�
function addAutoTab(title, url){
    if ($('#tabs').tabs('exists',title)){
        $('#tabs').tabs('select',title);
    }
    else{
        var content = '<iframe scrolling="auto" frameborder="0"  src="dhcpha.clinical.'+url+'.csp" style="width:100%;height:100%;"></iframe>';
        $('#tabs').tabs('add',{
            title:title,
            content:content,
            closable:true
        });
    }
}
